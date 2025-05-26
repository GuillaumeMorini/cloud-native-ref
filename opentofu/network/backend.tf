terraform {
  backend "gcs" {
    bucket  = "tofu-remote-backend"
    prefix  = "cloud-native-ref/network/opentofu.tfstate"
  }
}
