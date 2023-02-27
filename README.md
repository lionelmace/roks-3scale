# roks-3scale

## Pre Requisites

* ODF

## Installation

1. Install ROKS

1. Install ODF

1. Launch OpenShift Portal

1. Create a new Project such as `apim`

    ```sh
    oc new-project apim
    ```

### Registry Service Account

1. Create a Registry Service Account https://access.redhat.com/terms-based-registry/#/token/mace/openshift-secret

1. Download secret you created

1. Submit the secret to the cluster using this command:

    ```sh
    oc create -f mace-secret.yml
    oc secrets link default 12537132-mace-pull-secret --for=pull
    oc secrets link builder 12537132-mace-pull-secret
    ```

1. Connect to the cluster

### Create APIM

1. Go to Installed Operators

1. Create APIManager.

1. Select the YAML view and replace the wildcard domain example.com by the ROKS ingress domain.

1. APIM will create a PVC named `system-redis-storage` which gets created fine because ReadWriteOnce.

1. APIM will create a PVC named `system-storage` which gets created fine because ReadWriteOnce. Replace

    ```yaml
    spec:
        accessModes:
            - ReadWriteMany
        resources:
            requests:
            storage: 100Mi
        storageClassName: ibmc-vpc-block-10iops-tier
        volumeMode: Filesystem
    ```

    ```yaml
    spec:
        accessModes:
            - ReadWriteMany
        resources:
            requests:
            storage: 100Mi
        storageClassName: ocs-storagecluster-cephfs
        volumeMode: Filesystem
    ```

## Resources
