#!/bin/bash
source common_vars.sh

echo "==================================================================="
echo "                CONFIGURANDO FERRAMENTAS TERRAFORM                 "
echo "==================================================================="

if [[ -d tftools/tflint/${TFLINT_VERSION}/ && -d tftools/tfsec/${TFSEC_VERSION}/ && -d tftools/infracost/${INFRACOST_VERSION}/ && -d tftools/tfdocs/${TFDOCS_VERSION}/ && -d tftools/tf/${TF_VERSION}/ ]];

then echo "Diretórios de cache para as ferramentas já existem";

else

rm -rf tftools;
mkdir tftools;

apk add --no-cache unzip wget;

echo "==================================================================="
echo "DIRETÓRIOS DE CACHE"
echo "==================================================================="

mkdir -p tftools/tf/${TF_VERSION}/
mkdir -p tftools/tflint/${TFLINT_VERSION}/ ;
mkdir -p tftools/tfsec/${TFSEC_VERSION}/ ;
mkdir -p tftools/infracost/${INFRACOST_VERSION}/ ;
mkdir -p tftools/tfdocs/${TFDOCS_VERSION}/ ;

echo "==================================================================="
echo "TERRAFORM"
echo "==================================================================="

wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip;
unzip terraform_${TF_VERSION}_linux_amd64.zip;
chmod +x terraform; 
mv terraform tftools/tf/$TF_VERSION/ ;

echo "==================================================================="
echo "TFLINT"
echo "==================================================================="

wget https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip ;
unzip tflint_linux_amd64.zip;
mv tflint tftools/tflint/$TFLINT_VERSION/;

echo "==================================================================="
echo "TFSEC"
echo "==================================================================="

wget https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64;
mv tfsec-linux-amd64 tfsec;
chmod +x tfsec;
mv tfsec tftools/tfsec/$TFSEC_VERSION/;

echo "==================================================================="
echo "INFRACOST"
echo "==================================================================="

wget https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz;
tar -xvf infracost-linux-amd64.tar.gz;
chmod +x infracost-linux-amd64;
mv infracost-linux-amd64 tftools/infracost/${INFRACOST_VERSION}/infracost;

echo "==================================================================="
echo "TERRAFORM-DOCS"
echo "==================================================================="

wget https://github.com/terraform-docs/terraform-docs/releases/download/v${TFDOCS_VERSION}/terraform-docs-v${TFDOCS_VERSION}-linux-amd64.tar.gz;
tar -xzf terraform-docs-v${TFDOCS_VERSION}-linux-amd64.tar.gz;
chmod +x terraform-docs;
mv terraform-docs tftools/tfdocs/${TFDOCS_VERSION}/;

fi