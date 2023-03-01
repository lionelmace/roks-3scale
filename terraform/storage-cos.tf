##############################################################################
# COS Instance with 2 buckets: 
# - 1 bucket for 3scale APIManager
##############################################################################


# COS Variables
##############################################################################
variable "cos_plan" {
  description = "COS plan type"
  type        = string
  default     = "standard"
}

variable "cos_region" {
  description = "Enter Region for provisioning"
  type        = string
  default     = "global"
}

# COS Service for OpenShift Internal Registry
##############################################################################

resource "ibm_resource_instance" "cos" {
  name              = format("%s-%s", var.prefix, "cos")
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = var.cos_region
  resource_group_id = local.resource_group_id
  tags              = var.tags

  parameters = {
    service-endpoints = "private"
  }
}

## COS Bucket
##############################################################################
resource "ibm_cos_bucket" "cos-bucket" {
  bucket_name           = "cos-bucket-for-3scale"
  resource_instance_id  = ibm_resource_instance.cos.id
  storage_class         = "smart"
  cross_region_location = "eu"
  # region_location      = "eu-de"
  activity_tracking {
    read_data_events     = true
    write_data_events    = true
    activity_tracker_crn = local.activity_tracker_id
  }
  metrics_monitoring {
    usage_metrics_enabled   = true
    request_metrics_enabled = true
    metrics_monitoring_crn  = module.monitoring_instance.id
  }
  endpoint_type = "public"
  # allowed_ip = ["223.196.168.27", "223.196.161.38", "192.168.0.1"]
}


## IAM
##############################################################################

resource "ibm_iam_access_group_policy" "policy-cos" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Viewer"]

  resources {
    service           = "cloud-object-storage"
    resource_group_id = local.resource_group_id
  }
}
