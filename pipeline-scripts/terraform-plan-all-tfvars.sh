#!/bin/bash

source common_vars.sh
sh pipeline-scripts/$COMMON_STEPS_SCRIPT.sh
mv tftools/tf/${TF_VERSION}/terraform /usr/bin/
export STATE_BUCKET_KEY="key=bitbucket-pipelines/$BITBUCKET_PROJECT_KEY/$BITBUCKET_REPO_SLUG/apply/$BITBUCKET_BRANCH/$BITBUCKET_REPO_SLUG-$BITBUCKET_BUILD_NUMBER.tfstate"
cd pipeline/
terraform init -upgrade \
--backend-config="role_arn=$TF_VAR_role_arn" \
--backend-config="bucket=$STATE_BUCKET_NAME" \
--backend-config="dynamodb_table=$STATE_LOCK_TABLE" \
--backend-config=$STATE_BUCKET_KEY \
--backend-config="region=us-east-1"
for i in $(cat test_tfvars.txt); 
do 
echo "";
echo "===================================================================";
echo "EXECUTANDO O PLAN DE $i"; 
echo "===================================================================";
terraform plan -var-file="$i"; 
done