kubectl create namespace server-monitoring

# If your CA requires full chain, build it once:
cat /etc/secrets/certificate.crt /etc/secrets/ca_bundle.crt > /etc/secrets/fullchain.crt

# Prometheus (web TLS + client CA for mTLS)
kubectl create secret tls prometheus-tls \
  --cert=/etc/secrets/fullchain.crt \
  --key=/etc/secrets/private.key \
  -n server-monitoring
kubectl create secret generic prometheus-ca \
  --from-file=ca.crt=/etc/secrets/ca_bundle.crt \
  -n server-monitoring

# Alertmanager (web TLS + client CA for mTLS)
kubectl create secret tls alertmanager-tls \
  --cert=/etc/secrets/fullchain.crt \
  --key=/etc/secrets/private.key \
  -n server-monitoring
kubectl create secret generic alertmanager-ca \
  --from-file=ca.crt=/etc/secrets/ca_bundle.crt \
  -n server-monitoring

# Grafana (ingress TLS)
kubectl create secret tls grafana-tls \
  --cert=/etc/secrets/fullchain.crt \
  --key=/etc/secrets/private.key \
  -n server-monitoring