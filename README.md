# Kubernetes environment for The Public Knowledge Workshop's Migdar project

## Quickstart

[notebooks/quickstart.ipynb](notebooks/quickstart.ipynb)

## Moving from Gcloud to Kamatera

Renamed `environments/production` to `environments/production-gcloud`

Created new `environments/production` with values copied from production-gcloud

SSH to Kamatera NFS server, create paths:

```
mkdir -p /srv/default2/migdar/internal-search-ui /srv/default2/migdar/postgres /srv/default2/migdar/elasticsearch /srv/default2/migdar/pipelines
```

Connect to the Gcloud environment and export the secrets:

```
export KUBECONFIG=
source switch_environment.sh production-gcloud
mkdir -p environments/production/.secrets
kubectl get secret internal-search-ui-htpasswd --export -o yaml > environments/production/.secrets/internal-search-ui-htpasswd.yaml
kubectl get secret migdar --export -o yaml > environments/production/.secrets/migdar.yaml
kubectl get secret migdar-drive --export -o yaml > environments/production/.secrets/migdar-drive.yaml
kubectl get secret migdar-elasticsearch --export -o yaml > environments/production/.secrets/migdar-elasticsearch.yaml
kubectl get secret pipelines-db --export -o yaml > environments/production/.secrets/pipelines-db.yaml
```

Connect to the Kamatera environment, create the namespace and import the secrets

```
export KUBECONFIG=/path/to/kamatera/kubeconfig
source switch_environment.sh production
kubectl create ns migdar
kubectl apply -f environments/production/.secrets/internal-search-ui-htpasswd.yaml
kubectl apply -f environments/production/.secrets/migdar.yaml
kubectl apply -f environments/production/.secrets/migdar-drive.yaml
kubectl apply -f environments/production/.secrets/migdar-elasticsearch.yaml
kubectl apply -f environments/production/.secrets/pipelines-db.yaml
rm -rf environments/production/.secrets
```

Deploy:

```
export KUBECONFIG=/path/to/kamatera/.kubeconfig
source switch_environment.sh production
./helm_upgrade_external_chart.sh elasticsearch --install
./helm_upgrade_external_chart.sh postgres --install

# wait for elasticsearch and postgres to run

./helm_upgrade_external_chart.sh kibana --install
./helm_upgrade_external_chart.sh internal-search-ui --install
./helm_upgrade_external_chart.sh nginx --install
./helm_upgrade_external_chart.sh pipelines --install
./helm_upgrade_external_chart.sh search-api --install
./helm_upgrade_external_chart.sh web-ui --install
```
