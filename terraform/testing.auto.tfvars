##############################################################################
## Global Variables
##############################################################################
#ibmcloud_api_key = ""      # Set the variable export TF_VAR_ibmcloud_api_key=
prefix                = "my3scale"
region                = "eu-de" # eu-de for Frankfurt MZR
resource_group_name   = ""
tags                  = ["terraform", "3scale"]
activity_tracker_name = "platform-activities"


##############################################################################
## VPC
##############################################################################
vpc_classic_access            = false
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true


##############################################################################
## Cluster OpenShift
##############################################################################
openshift_cluster_name       = "roks"
openshift_version            = "4.11.22_openshift"
openshift_worker_pool_flavor = "bx2.4x16"

# Available values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
openshift_wait_till          = "IngressReady"
openshift_update_all_workers = false


##############################################################################
## COS
##############################################################################
cos_plan   = "standard"
cos_region = "global"


