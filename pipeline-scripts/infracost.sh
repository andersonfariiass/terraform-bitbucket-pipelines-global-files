#!/bin/bash
source common_vars.sh
sh pipeline-scripts/$COMMON_STEPS_SCRIPT.sh
mv tftools/infracost/${INFRACOST_VERSION}/infracost /usr/bin/
cd pipeline/
infracost breakdown --path .