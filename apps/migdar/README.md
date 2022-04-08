# Migdar app

This app contains all other apps as dependencies.

The app is continuously synced to Hasadna cluster via ArgoCD, see https://github.com/hasadna/hasadna-k8s/blob/master/docs/argocd.md

To diable the auto-sync (for debugging or to review changes before applying) -
login to https://argocd.hasadna.org.il and disable auto-sync for the migdar app.
