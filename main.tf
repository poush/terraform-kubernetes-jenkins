resource "kubernetes_persistent_volume_claim" "claim" {
  metadata {
    name      = "${var.name}-claim"
    namespace = var.namespace
    labels = {
      managedby = "terraform"
    }
  }
  spec {
    access_modes = [var.accessmode]
    resources {
      requests = {
        storage = var.request_storage
      }
    }
    storage_class_name = var.storageclass
    volume_name        = var.name
  }
}

resource "kubernetes_deployment" "jenkins" {
  depends_on = [kubernetes_persistent_volume_claim.claim]

  metadata {
    name = "${var.name}-deployment"
    labels = {
      managedby = "terraform"
    }
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          image = "civicactions/docker-jenkins"
          name  = var.name
          port {
            container_port = "8080"
          }
          volume_mount {
            name       = "${var.name}-persistent-storage"
            mount_path = "/var/jenkins_home"
          }
          #   TODO: liveness probe
        }
        security_context {
          fs_group = "1000"
        }
        volume {
          name = "${var.name}-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.claim.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins-service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      managedby = "terraform"
      service   = var.name
    }
  }
  spec {
    selector = {
      app = var.name
    }
    port {
      port = 8080
      name = "http"
    }

    type = "Service"
  }
}
