#!/bin/sh
source common_vars.sh
sh pipeline-scripts/$COMMON_STEPS_SCRIPT.sh
mv tftools/tf/${TF_VERSION}/terraform /usr/bin/

if [[  $branch == BRANCH_ATUAL ]]; 
then
export branch=$BITBUCKET_BRANCH;
else
export branch=$branch;
fi

export STATE_BUCKET_KEY="key=bitbucket-pipelines/$BITBUCKET_PROJECT_KEY/$BITBUCKET_REPO_SLUG/branch-apply/$branch/$BITBUCKET_REPO_SLUG-$build_number.tfstate"

cd pipeline/

terraform init -upgrade \
--backend-config="role_arn=$TF_VAR_role_arn" \
--backend-config="bucket=$STATE_BUCKET_NAME" \
--backend-config="dynamodb_table=$STATE_LOCK_TABLE" \
--backend-config=$STATE_BUCKET_KEY \
--backend-config="region=us-east-1"

terraform destroy -var-file="$BITBUCKET_REPO_SLUG.tfvars" -auto-approve