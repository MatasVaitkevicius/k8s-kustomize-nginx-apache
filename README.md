# k8s-kustomize-nginx-apache
## Overview
This project simplifies the deployment of Nginx and Apache within Kubernetes using Kustomize. It features overlays for both staging and production environments, streamlining the process of running these web servers on custom domains. A key component of this setup is the automation script that generates a self-signed certificate, ensuring secure communication for apache.local.com and nginx.local.com.

## Prerequisites
Kubernetes cluster
Kustomize
OpenSSL

## Getting Started

Start by cloning this repository to your local machine.
`git clone git@github.com:MatasVaitkevicius/k8s-kustomize-nginx-apache.git`

### Customize Configuration

Before running the setup script, you may need to customize the following configurations based on your environment:

- IP Address: Modify the IP_ADDRESS variable in the script if your target IP address differs from the default 127.0.0.1.
- Kubernetes Namespace: Adjust the NAMESPACE variable if you're using a namespace other than default.
- Common Name (CN): The CERT_CN variable should reflect the common name of your certificate; the default is local.com.

Run the Setup Script
./deploy-kubernetes-mac

Execute the provided script to set up your environment. This script performs several actions:
- Updates /etc/hosts with custom domains.
- Generates a self-signed certificate and keys.
- Creates a Kubernetes secret for the certificate.
- Applies the Kubernetes configuration with Kustomize.

Verify Deployment
Once the script completes, verify the deployment of Nginx and Apache pods within your Kubernetes cluster. Ensure that they are accessible via apache.local.com and nginx.local.com.

## Script Details
The deploy-kubernetes-mac.sh contains several key operations:

- Sudo Privilege Request: Requests sudo privileges at the start to ensure the script can perform operations requiring elevated permissions.
- Hosts Addition: Adds nginx.local.com and apache.local.com to your /etc/hosts.
- Certificate Generation: Utilizes OpenSSL to create a self-signed certificate.
- Kubernetes Secret Creation: Encodes the generated certificate and key, creating a Kubernetes secret.
- Kustomize Application: Applies Kubernetes configurations using Kustomize to deploy Nginx and Apache.
