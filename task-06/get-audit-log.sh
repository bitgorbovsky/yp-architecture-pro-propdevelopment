#!/usr/bin/env sh

TEMPFILE=$(mktemp minikube-audit.XXXXXXXXXX)

kubectl logs kube-apiserver-minikube -n kube-system | grep audit.k8s.io/v1 > $TEMPFILE
jq -f filter-audit-log.jq $TEMPFILE > audit-extract.json

rm $TEMPFILE
