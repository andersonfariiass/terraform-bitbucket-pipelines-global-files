#!/bin/bash
source common_vars.sh

echo "==================================================================="
echo "INSTALANDO PACOTES BÁSICOS" 
echo "==================================================================="

apk update && apk upgrade
apk add --no-cache figlet git perl bash openssh-client
apk add python3
eval $(ssh-agent)

echo "==================================================================="
echo "PYTHON E PRE-COMMIT"
echo "==================================================================="

wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
pip install pre-commit==$PRE_COMMIT_VERSION

echo "==================================================================="
echo "COLETANDO BINÁRIOS DAS FERRAMENTAS NO CACHE" 
echo "==================================================================="

mv tftools/tflint/${TFLINT_VERSION}/tflint /usr/bin/
mv tftools/tfsec/${TFSEC_VERSION}/tfsec /usr/bin/
mv tftools/tfdocs/${TFDOCS_VERSION}/terraform-docs /usr/bin/
mv tftools/tf/${TF_VERSION}/terraform /usr/bin/

echo "==================================================================="
echo "VERSÕES DAS FERRAMENTAS INSTALADAS" 
echo "==================================================================="

echo "TERRAFORM VERSION $(terraform -v | sed -n 1p |  cut -d " " -f 2)"
echo "PRE-COMMIT VERSION $(pre-commit -V | sed -n 1p | cut -d " " -f 2)"
echo "TFLINT VERSION $(tflint -v | cut -d " " -f 3 | sed -n 1p)"
echo "TFSEC VERSION $(tfsec --version)"
echo "TFDOCS VERSION $(terraform-docs --version | cut -d" " -f 3)"

echo "==================================================================="
echo "VERSÕES DOS PROVIDERS" 
echo "==================================================================="
terraform init -upgrade
echo "PROVDERS VERSIONS"
terraform providers

echo "==================================================================="
echo "PRE-COMMIT" 
echo "==================================================================="
pre-commit install
pre-commit run -a