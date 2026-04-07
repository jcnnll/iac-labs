#!/bin/bash
set -e

# Terraform (Official HashiCorp Tap)
if ! command -v terraform &>/dev/null; then
  echo "[INFO] Installing official Terraform..."
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
fi

# TFLint (Official Linter)
if ! command -v tflint &>/dev/null; then
  echo "[INFO] Installing TFLint..."
  brew install tflint
fi

# TFSec (Aqua Security)
if ! command -v tfsec &>/dev/null; then
  echo "[INFO] Installing TFSec..."
  brew install tfsec
fi

# Checkov (Bridgecrew/Prisma Cloud)
if ! command -v checkov &>/dev/null; then
  echo "[INFO] Installing Checkov..."
  # Note: brew install checkov is available, but pip is often
  # recommended for the most current CKV2 logic
  brew install checkov
fi

# Ansible-Lint
if ! command -v ansible-lint &>/dev/null; then
  echo "[INFO] Installing Ansible-Lint..."
  brew install ansible-lint
fi

# --- 2. Hardware Layer: Terraform ---
echo "[TEST] Running Terraform Validate..."
terraform -chdir=terraform validate

echo "[TEST] Running TFLint..."
tflint --init --config "$(pwd)/terraform/.tflint.hcl" --chdir=terraform
tflint --config "$(pwd)/terraform/.tflint.hcl" --chdir=terraform

echo "[TEST] Running tfsec..."
tfsec terraform

echo "[TEST] Running Checkov..."
checkov -d terraform

# --- 3. State Layer: Ansible ---
export ANSIBLE_DEPRECATION_WARNINGS=False
export PYTHONWARNINGS="ignore::DeprecationWarning"

echo "[TEST] Running Ansible-Lint..."
# Ensure collections are present for linter context
ansible-galaxy collection install -r ansible/requirements.yml
ansible-lint ansible/*.yml

echo "[SUCCESS] All checks passed!"
