## 🚀 Getting started


1. First of all we need to create the **supporting resources** such as the VPC and subnets using [this directory](../../../network/).

2. It is required to provide OpenBao's certificates (`.tls/openbao.pem`, `.tls/openbao-key.pem` and `ca-chain.pem`). You can create the certificates using [this procedure](pki_requirements.md)
   Store them in Google Cloud Secret Manager using these steps:

   ```bash
    SECRET_NAME="openbao"

    SECRETS_JSONFILE=$(mktemp)
    jq -nr --arg key "$(cat .tls/openbao-key.pem)" --arg cert "$(cat .tls/openbao.pem)" --arg ca "$(cat .tls/ca-chain.pem)" '{"cert":$cert,"key":$key,"ca":$ca}' > $SECRETS_JSONFILE

    # Create secrets in GCP Secret Manager
    gcloud secrets create $SECRET_NAME \
    --replication-policy="automatic"
    gcloud secrets versions add $SECRET_NAME --data-file=$SECRETS_JSONFILE

    # Clean up
    rm $SECRETS_JSONFILE
    ```

3. Prepare your `variables.tfvars` file:

```hcl
name                             = "openbao"                  # Name of your OpenBao instance
leader_tls_servername            = "bao.gmo-inc.com"          # OpenBao domain name that will be exposed to users
domain_name                      = "gmo-inc.com"              # DNS zone where to provision the DNS records
env                              = "dev"                      # Environment used to tags resources
mode                             = "dev"                      # Important: More about this setting in this documentation.
region                           = "eu-west-3"                # Where all the resources will be created
enable_ssm                       = true                       # Allow to access to the instances. Enabled for provisionning, but then it should be disabled.
openbao_certificates_secret_name = "openbao"                  # The name of the GCP Secret Manager secret containing the OpenBao certificates
```

4. Run the command `tofu apply --var-file variables.tfvars`

5. Connect to one of the instances using SSH and init the OpenBao instance:

Switch to the `root` user
```console
sudo su -
```

Initialize OpenBao as follows

```console
export VAULT_SKIP_VERIFY=true
bao operator init -recovery-shares=1 -recovery-threshold=1
```

You should get an output that contains the `Recovery Key` and the `Root Token`
```console
Recovery Key 1: 0vn2C31WbudlZS6...

Initial Root Token: hvs.LMKRyua5kJJ8...

Success! OpenBao is initialized
```

⚠️ **Important**: Throughout the entire installation and configuration process, it's essential to securely retain the `root` token. This token should be kept until all user accounts have been created. After this point, for enhanced security, the `root` token must be revoked.

Additionally, the `recovery key` requires careful handling. It should be securely stored in a highly safe location. Use the `recovery key` only in exceptionally rare situations, specifically when there is a need to generate a new `root` token. This key serves as a critical backup mechanism and should be treated with the utmost security.

1. Check that the cluster is working properly using the root token above

```console
bao login
```


You can also check the cluster's status. The important information below is that OpenBao is "Initialized" and not "Sealed".
```console
bao status
Key                      Value
---                      -----
Recovery Seal Type       shamir
Initialized              true
Sealed                   false
Total Recovery Shares    1
Threshold                1
Version                  1.14.8
Build Date               2023-12-04T17:45:23Z
Storage Type             raft
Cluster Name             openbao-cluster-6209d1c3
Cluster ID               a5055510-ab2d-3e91-8051-d58a3041a47d
HA Enabled               true
HA Cluster               https://10.0.0.213:8201
HA Mode                  active
Active Since             2024-01-05T08:20:52.862058318Z
Raft Committed Index     43
Raft Applied Index       43
```
