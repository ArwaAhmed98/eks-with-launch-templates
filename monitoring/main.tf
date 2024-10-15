/*
important commands to install, update, and uninstall Grafana helm package manually:

helm upgrade -i monitoring prometheus-community/kube-prometheus-stack --namespace monitoring-stack -f values.yaml
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring-stack -f values.yaml
helm uninstall monitoring --namespace monitoring-stack -f values.yaml
kubectl apply -f grafana_ini.yaml
kubectl apply -f grafana_manifests.yaml
kubectl rollout restart deployment -n monitoring-stack monitoring-grafana
*/ 

data "template_file" "grafana_ini" {
  template = file("${path.module}/templates/grafana_ini.yaml")
}

data "template_file" "grafana_manifests" {
  template = file("${path.module}/templates/grafana_manifests.yaml")
}


data "template_file" "grafana_values" {
  template = file("${path.module}/templates/values.yaml")
}

resource "helm_release" "monitoring" {
  name            = "prometheus"
  repository      = "https://prometheus-community.github.io/helm-charts"
  chart           = "kube-prometheus-stack"
  namespace       = "monitoring-stack"
  values = [ data.template_file.grafana_values.rendered ]
  # set {
  #   name = "server.service.type"
  #   value = "NodePort"
  # }
}

resource "null_resource" "update_config" {
  depends_on = [helm_release.monitoring]
  provisioner "local-exec" {
    command = <<EOT
      echo  '${data.template_file.grafana_ini.rendered}' | kubectl apply -f -
      echo  '${data.template_file.grafana_manifests.rendered}' | kubectl apply -f -
      kubectl rollout restart deployment -n monitoring-stack monitoring-grafana
    EOT
  }
}
