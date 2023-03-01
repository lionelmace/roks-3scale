# Install 3scale on ROKS

## Prerequisites

* A cluster ROKS
* A COS bucket

## Installation

1. Install ROKS

1. Launch OpenShift Portal

1. Set the value of the project name.

    ```sh
    export OPENSHIFT_PROJECT=
    ```

1. Create a new Project such as `apim`

    ```sh
    oc new-project apim
    ```

## Registry Service Account

1. Create a Registry Service Account https://access.redhat.com/terms-based-registry/#/accounts

1. Set the value of the token.

    ```sh
    export TOKEN_USERNAME=<your-token-username>
    export TOKEN_PASSWORD=<your-token-password>
    ```

1. Submit the secret to the cluster using this command:

    ```sh
    oc create secret docker-registry threescale-registry-auth \
    --docker-server=registry.redhat.io \
    --docker-username=$TOKEN_USERNAME \
    --docker-password=$TOKEN_PASSWORD
    
    > --docker-email="lionel.mace@fr.ibm.com"

1. Connect to the cluster

## Create APIManager

1. Replace the cluster-name (including <>) with the the cluster name.

    ```sh
    export CLUSTER_NAME=<your-cluster-name>
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
