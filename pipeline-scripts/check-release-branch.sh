#!/bin/bash
if [[ $BITBUCKET_BRANCH == release/* || $BITBUCKET_BRANCH == hotfix/* ]] ; 
then 
echo "Branch de release ou hotfix"; 
else
echo "Branch não é de release ou de hotfix";
exit 1;
fi