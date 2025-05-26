# Network and VPN server

This module deploys several things:

* Base network resources: VPC network, subnets, Cloud Router, Cloud NAT

## Prerequisites

* Generate an API key

Create the `variables.tfvars` file

```hcl
gcp_project_id    = "cloud-native-ref"
gcp_region        = "europe-west9"
gcp_zone          = "europe-west9-c"

```


## Apply

```console
cd opentofu/network
tofu init
tofu apply --var-file variables.tfvars
```

