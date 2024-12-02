#!/bin/bash
apk update
apk add --no-cache git npm
git remote set-url origin https://$BITBUCKET_USER:$BITBUCKET_APP_PASSWORD@bitbucket.org/$BITBUCKET_WORKSPACE/$BITBUCKET_REPO_SLUG.git
npm install \
conventional-changelog-conventionalcommits@6.1.0 \
@semantic-release/git@10.0.1 \
@semantic-release/changelog@6.0.3 \
env-ci@9.1.1 \
@semantic-release/commit-analyzer@10.0.1 \
@semantic-release/release-notes-generator@11.0.4
npx semantic-release@18