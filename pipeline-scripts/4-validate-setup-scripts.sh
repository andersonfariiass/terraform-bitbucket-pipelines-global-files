#!/bin/bash
apk add --no-cache wget

YQ_VERSION="4.34.2"
YQ_DIR="tools/yq/$YQ_VERSION/"

if [[ -d $YQ_DIR ]];

then echo "Diretório de cache para YQ já existe";
else
mkdir -p $YQ_DIR;
wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -O ${YQ_DIR}/yq;
chmod +x ${YQ_DIR}/yq;
fi

cp $YQ_DIR/yq /usr/bin

if [[ $(yq e '.definitions.steps[0].step.script[0]' bitbucket-pipelines.yml | cut -d " " -f 2-4) == "REF=\$GIT_BRANCH_TERRAFORM_GLOBAL_PRIVATE" ]];

then

echo "Sucesso - está sendo usada a variável '$GIT_BRANCH_TERRAFORM_GLOBAL_PRIVATE' para definir a branch do repositório de scripts (Primeiro step da pipeline)"

else

echo "Falha - favor usar a a variável '$GIT_BRANCH_TERRAFORM_GLOBAL_PRIVATE' para definir a branch do repositório de scripts (Primeiro step da pipeline)"

exit 1;

fi