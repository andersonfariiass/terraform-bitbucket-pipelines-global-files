#!/bin/bash

if [[ $BITBUCKET_BRANCH == apply/* ]] ; 
then 
echo "Branch de apply para pipeline"; 
else
echo "Branch não é de apply";
exit 1;
fi
