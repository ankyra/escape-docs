#!/bin/bash -e

DEPS="deps/heist/escape-integration-tests/deps"

rm -rf content/docs
mkdir -p content/
cp -r ${DEPS}/_/escape/docs/cmd content/docs
cp ${DEPS}/_/escape/docs/generated/*.md content/docs
cp ${DEPS}/_/escape/docs/*.md content/docs/
cp ${DEPS}/_/escape/vendor/github.com/ankyra/escape-core/docs/generated/*.md content/docs/
cp ${DEPS}/_/escape/vendor/github.com/ankyra/escape-core/docs/*.md content/docs/
cp ${DEPS}/_/escape-inventory/docs/*.md content/docs/

hugulp build

if [ -z $SKIP_BUILD ] ; then 
    deps/_/extension-docker-kubespec/build.sh $@
fi
