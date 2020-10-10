#!/usr/bin/env bash

header_text "Install the latest version of Istio and the demo app. See https://istio.io/latest/docs/setup/getting-started/"
set -eu
set -o pipefail

# Turn colors in this script off by setting the NO_COLOR variable in your
# environment to any value:
#
# $ NO_COLOR=1 test.sh
NO_COLOR=${NO_COLOR:-""}
if [ -z "$NO_COLOR" ]; then
  header=$'\e[1;33m'
  reset=$'\e[0m'
else
  header=''
  reset=''
fi

istio_version=1.7.3

function header_text {
  echo "$header$*$reset"
}

header_text "Using Istio Version: ${istio_version}"

filename=istio-${istio_version}-win.zip
header_text "Downloading Istio ${filename}"

pushd ./tmp > /dev/null
export ISTIO_VERSION="${istio_version}"
curl -L https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/${filename} --output ${filename}

header_text "Extracting Istio"
# tar -xzf "${filename}"
unzip -o "${filename}"
rm "${filename}"

pushd istio-${ISTIO_VERSION} > /dev/null

header_text "Add $PWD/bin to the path" 
export PATH=$PWD/bin:$PATH

header_text "Install Istio. Setup using a testing style configuration profile"
istioctl install --set profile=demo

header_text "Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies when you deploy your application."
kubectl label namespace default istio-injection=enabled

header_text "Deploy "
kubectl apply -f samples/httpbin/httpbin.yaml

header_text "Deploy the Bookinfo sample application"
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

header_text "Create an istio gateway"
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: httpbin-gateway
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "httpbin.example.com"
EOF

header_text "Configure routes for traffic entering via the Gateway"
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: httpbin
spec:
  hosts:
  - "httpbin.example.com"
  gateways:
  - httpbin-gateway
  http:
  - match:
    - uri:
        prefix: /status
    - uri:
        prefix: /delay
    route:
    - destination:
        port:
          number: 8000
        host: httpbin
EOF

popd > /dev/null
popd > /dev/null