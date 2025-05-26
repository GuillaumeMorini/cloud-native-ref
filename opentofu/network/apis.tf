#
# ServiceUsage and CloudResourceManager are special APIs that need to be enabled first.
# There are indeed some race conditions in the "project-services" module that prevent other APIs
# to be provisioned properly.
# The first resource provisioning happens after the `wait_project_init` resource has been initialized.
#


#
# APIs to be enabled for this project
#
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.0"

  project_id = var.gcp_project_id

  activate_apis = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "orgpolicy.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}