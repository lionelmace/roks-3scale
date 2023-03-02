# Install 3scale on ROKS

## Prerequisites

* An IBM Cloud Account with Admin acces rights
* A cluster ROKS
* A COS bucket

## Create the environment

Terraform is used to provision a complete environment with the cluster, the COS bucket.

1. Initialize the terraform

    ```sh
    terraform init
    ```

1. Generate a plan

    ```sh
    terraform plan -var-file="testing.auto.tfvars"
    ```

1. Apply the Terraform plan

    ```sh
    terraform apply -var-file="testing.auto.tfvars"
    ```

> You can also provision this environement using IBM Cloud Schematics.

## Connect to the OpenShift Cluster

1. Connect to the OpenShift cluster via the CLI

    ```sh
    ibmcloud ks cluster config --cluster my3scale-roks --admin
    ```

1. Set the project name.

    ```sh
    export THREESCALE_PROJECT=my3scale
    ```

1. Create a new Project

    ```sh
    oc new-project $THREESCALE_PROJECT
    ```

## Configure the RH Registry Service Account

1. Create a Registry Service Account https://access.redhat.com/terms-based-registry/#/accounts

1. Set the value of the token.

    ```sh
    export TOKEN_USERNAME="<your-token-username>"
    export TOKEN_PASSWORD="<your-token-password>""
    ```

1. Submit the secret to the cluster using this command:

    ```sh
    oc create secret docker-registry threescale-registry-auth \
    --docker-server=registry.redhat.io \
    --docker-username=$TOKEN_USERNAME \
    --docker-password=$TOKEN_PASSWORD
    ```

1. Link the secret to your project

    ```sh
    oc secrets link default threescale-registry-auth --for=pull
    oc secrets link builder threescale-registry-auth
    ```

    > --docker-email="lionel.mace@fr.ibm.com"

## Configure access to IBM Cloud COS

1. Create a file cos-credentials.env from a template

    ```sh
    cp cos-credentials.env.template cos-credentials.env
    ```

1. Edit the credentials with your COS HMAC key, bucket and endpoint information

    ```txt
    AWS_ACCESS_KEY_ID=<replace_with_cos_hmac_keys_access_key_id>
    AWS_SECRET_ACCESS_KEY=<replace_with_cos_hmac_keys_secret_access_key>
    AWS_BUCKET=cos-bucket-for-3scale
    AWS_HOSTNAME=s3.eu-de.cloud-object-storage.appdomain.cloud
    AWS_REGION=eu-de
    ```

1. Create the secret in the project

    ```sh
    oc create secret generic ibmcloud-cos-credentials --namespace=$THREESCALE_PROJECT --from-env-file=cos-credentials.env
    ```

## Install the 3scale operator

1. xx

## Create the 3scale APIManager

APIManager requires a wildcard DNS domain. We will use the ingress domain automatically created at the cluster provisioning time.

1. Replace the cluster-name (including <>) with the the cluster name.

    ```sh
    export CLUSTER_NAME=<your-cluster-name>
    ```

    Example: Terraform will create a cluster named `my3scale-roks` by default.

    ```sh
    export CLUSTER_NAME=my3scale-roks
    ```

1. Retrieve and set the value of the cluster ingress subdomain.

    ```sh
    export INGRESS_DOMAIN=$(ibmcloud ks cluster get -c $CLUSTER_NAME | grep "Ingress Subdomain" | awk '{print tolower($3)}')
    ```

1. Verify the value you set

    ```sh
    echo $INGRESS_DOMAIN
    ```

1. Create the APIManager

    ```sh
    oc apply -f - <<EOF
    ---
    apiVersion: apps.3scale.net/v1alpha1
    kind: APIManager
    metadata:
      name: example-apimanager
    spec:
      wildcardDomain: $INGRESS_DOMAIN
      system:
        fileStorage:
        simpleStorageService:
            configurationSecretRef:
            name: ibmcloud-cos-credentials
    EOF
    ```

## Resources

* [3scale complete installation guide](https://access.redhat.com/documentation/en-us/red_hat_3scale_api_management/2.13/html/installing_3scale/index)
