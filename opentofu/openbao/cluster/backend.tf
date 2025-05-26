terraform {
  backend "gcs" {
    bucket  = "tofu-remote-backend"
    prefix  = "cloud-native-ref/openbao/opentofu.tfstate"
  }
}
