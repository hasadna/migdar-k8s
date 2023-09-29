# Kubernetes environment for The Public Knowledge Workshop's Migdar project

Infrastructure is defined as a helm chart under `apps/migdar/`

This chart contains all other charts as helm dependencies.

The chart is continuously synced to Hasadna cluster via ArgoCD as defined 
[here](https://github.com/hasadna/hasadna-k8s/blob/master/apps/hasadna-argocd/templates/).
