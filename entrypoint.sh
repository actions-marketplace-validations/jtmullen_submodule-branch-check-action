#!/bin/sh -l

echo "I am here"
echo "Print Refs"

echo "${GITHUB_REF}"

echo "${GITHUB_SHA}"

REPO=`jq -r ".repository.full_name" "${GITHUB_EVENT_PATH}"`

cd "${GITHUB_WORKSPACE}"

PR=`jq -r ".number" "${GITHUB_EVENT_PATH}"`
echo "PR: ${PR}"

BASE_URI="https://api.github.com"
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"


git config --global user.email "submodule@github.com"
git config --global user.name "GitHub Submodules Action"

git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/${REPO}.git
git fetch --all -p

git checkout master

git submodule init
git submodule update

cd Libraries
lib_hash=`git rev-parse HEAD`

cd ..
git checkout "${GITHUB_REF}"
git submodule update

cd Libraries
master_lib_hash=`git rev-parse HEAD`

echo "Hash: ${master_lib_hash} -> ${lib_hash}"

echo "::set-output name=fails::0"

exit 0
