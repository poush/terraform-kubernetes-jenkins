variable "request_storage" {
  default = "5Gi"
}

variable "accessmode" {
  default = "ReadWriteOnce"
}

variable "name" {
  default = "jenkins"
}

variable "namespace" {
  default = "jenkins"
}

variable "storageclass" {
  default = "gp2"
}
