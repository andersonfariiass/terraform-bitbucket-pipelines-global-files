#!/bin/bash
source common_vars.sh
sh pipeline-scripts/$COMMON_STEPS_SCRIPT.sh
mv tftools/tf/${TF_VERSION}/terraform /usr/bin/
export STATE_BUCKET_KEY="key=bitbucket-pipelines/$BITBUCKET_PROJECT_KEY/$BITBUCKET_REPO_SLUG/apply/$BITBUCKET_BRANCH/$BITBUCKET_REPO_SLUG-$BITBUCKET_BUILD_NUMBER.tfstate"
echo $BITBUCKET_PROJECT_KEY
cd pipeline/

terraform init \
-upgrade \
--backend-config="role_arn=$TF_VAR_role_arn" \
--backend-config="bucket=$STATE_BUCKET_NAME" \
--backend-config="dynamodb_table=$STATE_LOCK_TABLE" \
--backend-config=$STATE_BUCKET_KEY \
--backend-config="region=us-east-1"

terraform plan -var-file="$BITBUCKET_REPO_SLUG.tfvars"