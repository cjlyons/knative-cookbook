#!/bin/bash

set -eu

PROFILE_NAME=${PROFILE_NAME:-knativecookbook}
MEMORY=${MEMORY:-7680}
CPUS=${CPUS:-4}

EXTRA_CONFIG="apiserver.enable-admission-plugins=\
LimitRanger,\
NamespaceExists,\
NamespaceLifecycle,\
ResourceQuota,\
ServiceAccount,\
DefaultStorageClass,\
MutatingAdmissionWebhook"

minikube start -p $PROFILE_NAME --memory=$MEMORY --cpus=$CPUS \
  --disk-size=50g \
  --extra-config="$EXTRA_CONFIG" \
  --insecure-registry='10.0.0.0/24' 

minikube profile $PROFILE_NAME

# minikube start -p knativecookbook --memory=7680 --cpus=4 --disk-size=50g --extra-config="apiserver.enable-admission-plugins=LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook" --insecure-registry='10.0.0.0/24' 