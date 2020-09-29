#!/bin/bash

set -eu

PROFILE_NAME=${PROFILE_NAME:-knativecookbook}

minikube stop -p $PROFILE_NAME