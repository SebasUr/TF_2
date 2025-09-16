#!/usr/bin/env bash
# Export AWS temporary credentials into your current shell.
# Usage (zsh/bash):
#   source ./deployment/export_aws_creds.sh

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
export AWS_REGION="us-east-1"
export AWS_DEFAULT_REGION="us-east-1"

echo "Exported AWS creds to current shell for region ${AWS_REGION}."
