#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

sudo apt-get update -y
sudo apt-get install -y jq gpg snapd wget

region="europe-west9"

openbao_data_path=/opt/openbao/data
mkdir -p $openbao_data_path

echo "OpenBao init"

export DEBIAN_FRONTEND=noninteractive

INSTANCE_ID=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/id" -H "Metadata-Flavor: Google")
PRIVATE_IP=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google")
openbao_version=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/openbao_version" -H "Metadata-Flavor: Google")
PROJECT_ID=$(curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")

# Install OpenBao
# ---------------
## Set URLs for the binary, signature, and GPG key
OPENBAO_VERSION="${openbao_version}"
eval OPENBAO_BINARY="bao_$OPENBAO_VERSION""_linux_amd64.deb"
BINARY_URL="https://github.com/openbao/openbao/releases/download/v$OPENBAO_VERSION/$OPENBAO_BINARY"
SIGNATURE_URL="https://github.com/openbao/openbao/releases/download/v$OPENBAO_VERSION/$OPENBAO_BINARY.gpgsig"
GPG_KEY_URL="https://openbao.org/assets/openbao-gpg-pub-20240618.asc"

## Download the binary, signature, and GPG key
wget -q "$BINARY_URL" -O $OPENBAO_BINARY
wget -q "$SIGNATURE_URL" -O $OPENBAO_BINARY.gpgsig
wget -q "$GPG_KEY_URL" -O openbao-gpg-pub.asc

## Import the OpenBao public key
gpg --import openbao-gpg-pub.asc

## Verify the signature
gpg --verify $OPENBAO_BINARY.gpgsig $OPENBAO_BINARY
if [ $? -ne 0 ]; then
  echo "Signature verification failed!"
  exit 1
else
  echo "Signature verified successfully!"
fi

## Install the binary
dpkg -i $OPENBAO_BINARY

## Clean up
rm $OPENBAO_BINARY $OPENBAO_BINARY.gpgsig openbao-gpg-pub.asc

# Configure OpenBao
# -----------------
chown openbao:openbao /etc/openbao/openbao.hcl
chown -R openbao:openbao ${openbao_data_path}
chown root:openbao /opt/openbao/tls/tls.key
chmod 660 /opt/openbao/tls/tls.key

cat << EOF > /etc/openbao/openbao.hcl
cluster_addr  = "https://$PRIVATE_IP:8201"
api_addr      = "https://$PRIVATE_IP:8200"
ui            = true

listener "tcp" {
  address = "[::]:8200"
  cluster_address = "[::]:8201"
  tls_cert_file      = "/opt/openbao/tls/tls.crt"
  tls_key_file       = "/opt/openbao/tls/tls.key"
  tls_client_ca_file = "/opt/openbao/tls/ca.pem"
  telemetry {
    unauthenticated_metrics_access = true
  }
}


storage "file" {
  path = "${openbao_data_path}"
}

seal "gcpckms" {
  project     = "${PROJECT_ID}"
  region      = "global"
  key_ring    = "openbao-kms"
  crypto_key  = "openbao-key"
}

EOF

systemctl start openbao.service
systemctl enable openbao.service
