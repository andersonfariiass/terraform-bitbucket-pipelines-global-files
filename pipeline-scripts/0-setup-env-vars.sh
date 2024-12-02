#!/bin/bash
export AUX=true

echo "====================================================================="
echo "               CONFIGURANDO VARIÁVEIS DE AMBIENTE                    "
echo "====================================================================="

echo export STATE_BUCKET_NAME=s3-terraform-backend-brlink-bitbucket-pipelines > common_vars.sh
echo export STATE_LOCK_TABLE=dynamodb-terraform-backend-brlink-bitbucket-pipelines >> common_vars.sh
echo export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugins" >> common_vars.sh
echo export TF_VAR_role_arn=${AWS_ROLE_ARN} >> common_vars.sh
echo export TF_VAR_bitbucket_project_key=$BITBUCKET_PROJECT_KEY >> common_vars.sh
echo export TF_VAR_bitbucket_repo_slug=$BITBUCKET_REPO_SLUG >> common_vars.sh
echo export TF_VAR_bitbucket_pr_destination_branch=$BITBUCKET_PR_DESTINATION_BRANCH >> common_vars.sh
echo export TF_VAR_bitbucket_build_number=$BITBUCKET_BUILD_NUMBER >> common_vars.sh
echo export PRE_COMMIT_VERSION=3.2.0 >> common_vars.sh
echo export TF_VERSION=1.1.5 >> common_vars.sh
echo export TFLINT_VERSION=0.43.0 >> common_vars.sh
echo export TFSEC_VERSION=1.28.1 >> common_vars.sh
echo export TFDOCS_VERSION=0.16.0 >> common_vars.sh
echo export INFRACOST_VERSION=0.10.18 >> common_vars.sh
echo export TFSWITCH_VERSION=0.13.1308 >> common_vars.sh
echo export COMMON_STEPS_SCRIPT=common_steps >> common_vars.sh

echo "====================================================================="
echo "                  CHECAGEM DE PASTAS E ARQUIVOS                      "
echo "====================================================================="
PASTAS_ESSENCIAIS="pipeline .tfsec pipeline/.tfsec"
ARQUIVOS_ESSENCIAIS=".pre-commit-config.yaml .tflint.hcl .terraform-docs.yml .releaserc.json .tfsec/config.yml .tfsec/tags_aws_tfchecks.yaml README.md .gitignore"

for i in $(echo $PASTAS_ESSENCIAIS); 
do 
echo "";
echo "===================================================================";
echo "CHECANDO A PASTA $i"; 
echo "===================================================================";
ls -d $i;
done

for i in $(echo $ARQUIVOS_ESSENCIAIS); 
do 
echo "";
echo "===================================================================";
echo "CHECANDO O ARQUIVO $i"; 
echo "===================================================================";
ls $i;
done


echo "====================================================================="
echo "                      CONFIGURANDO TFVARS                            "
echo "====================================================================="
cd pipeline/

for i in $1 ; 
do 
echo "";
echo "===================================================================";
echo "COLETANO OS TFVARS DE $i"; 
echo "===================================================================";
ls "$i"_*.tfvars;
ls "$i"_*.tfvars >> test_tfvars.txt;
echo "==================================================================="; 
done

for i in $1
do
    export tfvars=$(printenv "${i}_tfvars")
    if [[ "${tfvars}.tfvars" != ".tfvars" ]];
    then
    echo ""; 
    echo "==================================================================="; 
    echo "TFVars customizado, variável ${i}_tfvars: OK"
    echo "==================================================================="; 
    export AUX=false
    else
    export AUX=true;
    break;
    fi
done

if [[ $AUX == true ]]
then
echo "Pipeline automática. Sem definição de tfvars customizado";
touch $BITBUCKET_REPO_SLUG.tfvars;
else
for i in $1
do
    echo $i
    export tfvars_centralizado=$(printenv "${i}_tfvars")
    cat "${tfvars_centralizado}.tfvars" >> $BITBUCKET_REPO_SLUG.tfvars
    echo  "" >> $BITBUCKET_REPO_SLUG.tfvars
done
fi