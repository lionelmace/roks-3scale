##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter"
  type        = string
  default     = ""
}

variable "region" {
  description = "IBM Cloud region where all resources will be provisioned"
  default     = "eu-de"
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf"]
}


##############################################################################
# VPC Variables
##############################################################################

variable "create_vpc" {
  description = "True to create new VPC. False if VPC is already existing and subnets or address prefixies are to be added"
  type        = bool
  default     = true
}

variable "vpc_classic_access" {
  description = "Classic Access to the VPC"
  type        = bool
  default     = false
}

variable "vpc_address_prefix_management" {
  description = "Default address prefix creation method"
  type        = string
  default     = "manual"
}

variable "vpc_acl_rules" {
  default = [
    {
      name        = "egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
  ]
}

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for Address Prefix"
  default = [
    "10.243.0.0/18",
    "10.243.64.0/18",
  "10.243.128.0/18"]
}

variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for subnets"
  default = [
    "10.243.0.0/24",
    "10.243.64.0/24",
  "10.243.128.0/24"]
}

variable "vpc_enable_public_gateway" {
  description = "Enable public gateways, true or false"
  default     = true
}

variable "floating_ip" {
  description = "Floating IP `id`'s or `address`'es that you want to assign to the public gateway"
  type        = map(any)
  default     = {}
}