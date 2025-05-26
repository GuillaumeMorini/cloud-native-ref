gcp_project_id    = "cloud-native-ref"
gcp_region        = "europe-west9"
gcp_zone          = "europe-west9-c"
network_name                     = "cn-network"               # Name of the network where the instances will be created
subnet_name                      = "cn-subnet"                # Name of the subnet where the instances will be created
subnet_iprange                   = "10.0.0.0/16"              # IP range of the subnet
prometheus_node_exporter_enabled = true                       # If set to true install and start a prometheus node exporter
name                             = "openbao"                  # Name of your OpenBao instance
leader_tls_servername            = "bao.gmo-inc.com"          # OpenBao domain name that will be exposed to users
domain_name                      = "gmo-inc.com"              # DNS zone where to provision the DNS records
env                              = "dev"                      # Environment used to tags resources
mode                             = "dev"                      # Important: More about this setting in this documentation.
enable_ssm                       = true                       # Allow to access to the instances. Enabled for provisionning, but then it should be disabled.
openbao_certificates_secret_name = "openbao"                  # The name of the GCP Secret Manager secret containing the OpenBao certificates

