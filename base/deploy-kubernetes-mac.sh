#!/bin/bash

# Ask for the sudo upfront
sudo -v

# Hosts to add to /etc/hosts
HOSTS=("nginx.local.com" "apache.local.com")

# IP address you want to point your hosts to
IP_ADDRESS="127.0.0.1"

# Path to the openssl configuration file
OPENSSL_CONF="openssl.cnf"

# Kubernetes secret name
SECRET_NAME="secret-cert"

# Kubernetes namespace (adjust if you use a specific namespace)
NAMESPACE="default"

# The Common Name (CN) of your certificate
CERT_CN="local.com"

# Path to the generated certificate
CERT_FILE="tls.crt"
KEY_FILE="tls.key"

# Add hosts to /etc/hosts
for HOST in "${HOSTS[@]}"; do
  if ! grep -q "$HOST" /etc/hosts; then
    echo "$IP_ADDRESS $HOST" | sudo tee -a /etc/hosts > /dev/null
    echo "Added $HOST to /etc/hosts"
  else
    echo "$HOST already exists in /etc/hosts"
  fi
done

# Check if the Kubernetes secret file already exists
if [ -f "$SECRET_NAME.yaml" ]; then
  echo "Kubernetes secret file $SECRET_NAME.yaml already exists, skipping creation."
else
  # Generate keys
  echo "Generating certificate keys..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$KEY_FILE" -out "$CERT_FILE" -config "$OPENSSL_CONF"

  # Add generated certificate to keychain
  echo "Adding generated certificate to keychain..."
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain tls.crt

  ENCODED_CERT=$(base64 < "$CERT_FILE")
  ENCODED_KEY=$(base64 < "$KEY_FILE")

    # Create the Kubernetes secret YAML file if it doesn't exist
    cat <<EOF > $SECRET_NAME.yaml
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $NAMESPACE
type: kubernetes.io/tls
data:
  tls.crt: $ENCODED_CERT
  tls.key: $ENCODED_KEY
EOF
fi

# Apply Kubernetes configuration with Kustomize
echo "Applying kubernetes..."
kubectl apply -k .

# Clean up generated files
rm "$CERT_FILE" "$KEY_FILE"

echo "Script execution completed."
