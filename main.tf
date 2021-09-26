#Helm install of sample app on IKS
data "terraform_remote_state" "iksws" {
  backend = "remote"
  config = {
    organization = "Lab14"
    workspaces = {
      name = var.ikswsname
    }
  }
}

variable "ikswsname" {
  type = string
}
variable "url" {
  type = string
}
variable "account" {
  type = string
}
variable "username" {
  type = string
}
variable "password" {
  type = string
}
variable "accessKey" {
  type = string
}
variable "namespaces" {
  type = string 
}

resource helm_release appdiksfrtfcb {
  name       = "appdcluster"
  namespace = "appdynamics"
  chart = "https://prathjan.github.io/helm-chart/cluster-agent-0.1.18.tgz"

  set {
    name  = "controllerInfo.url"
    value = var.url 
  }
  set {
    name  = "controllerInfo.account"
    value = var.account
  }
  set {
    name  = "controllerInfo.username"
    value = var.username
  }
  set {
    name  = "controllerInfo.password"
    value = var.password
  }
  set {
    name  = "controllerInfo.accessKey"
    value = var.accessKey
  }
  set {
    name  = "clusterAgent.nsToMonitor"
    value = "{ default,appdynamics }"
  }
  set {
    name  = "install.metrics-server"
    value = "true"
  }
  set {
    name  = "instrumentationConfig.imageInfo.java.image"
    value = "docker.io/appdynamics/java-agent:21.3.0"
  }
  set {
    name  = "instrumentationConfig.imageInfo.java.agentMountPath"
    value = "/opt/appdynamics"
  }
  set {
    name  = "instrumentationConfig.imageInfo.java.imagePullPolicy"
    value = "Always"
  }
  set {
    name  = "instrumentationConfig.enabled"
    value = "true"
  }
  set {
    name  = "instrumentationConfig.instrumentationMethod"
    value = "Env"
  }
  set {
    name  = "instrumentationConfig.nsToInstrumentRegex"
    value = "default"
  }
  set {
    name  = "instrumentationConfig.defaultAppName"
    value = "IKSChaiStore"
  }
  set {
    name  = "instrumentationConfig.appNameStrategy"
    value = "namespace"
  }
  set {
    name  = "instrumentationConfig.appNameStrategy"
    value = "namespace"
  }
}

provider "helm" {
  kubernetes {
    host = local.kube_config.clusters[0].cluster.server
    client_certificate = base64decode(local.kube_config.users[0].user.client-certificate-data)
    client_key = base64decode(local.kube_config.users[0].user.client-key-data)
    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
  }
}

locals {
  kube_config = yamldecode(data.terraform_remote_state.iksws.outputs.kube_config)
}

