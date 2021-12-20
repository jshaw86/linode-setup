#!/bin/bash

if [ -z "${1}" -a -z "${2}" ]; then
    echo "usage ./linode.sh ./relative/path/to/cert.crt ./relative/path/to/private-key.pem"
else
    kubectl create namespace nginx 2> /dev/null

    kubectl create secret tls linode-lb-secret --cert $1 --key $2 -n nginx 2> /dev/null

    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm upgrade -i ingress-nginx -n nginx ingress-nginx/ingress-nginx --values helm/ingress-controller-values.yaml --wait

    helm upgrade -i hello-world -n hello-kubernetes ./helm/hello-kubernetes --wait
fi





