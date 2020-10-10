REM setup the environment variables
for /f "delims=" %%i in ('kubectl -n istio-system get service istio-ingressgateway -o yaml  ^| yq r - "spec.ports(name==http2).nodePort"') do set INGRESS_PORT=%%i
for /f "delims=" %%i in ('kubectl -n istio-system get service istio-ingressgateway -o yaml  ^| yq r - "spec.ports(name==https).nodePort"') do set SECURE_INGRESS_PORT=%%i
for /f "delims=" %%i in ('minikube ip') do set INGRESS_HOST=%%i
set GATEWAY_URL=%INGRESS_HOST%:%INGRESS_PORT%
REM minikube tunnel
