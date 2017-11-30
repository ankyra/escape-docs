#!/bin/bash -e

DEPS="deps/heist/escape-integration-tests/deps"

rm -rf content/docs/reference/
mkdir -p content/docs/reference/

cp -r ${DEPS}/_/escape/docs/cmd/*.md content/docs/reference

cp ${DEPS}/_/escape/docs/generated/*.md content/docs/reference/
cp ${DEPS}/_/escape/docs/*.md content/docs/reference/
cp ${DEPS}/_/escape/docs/*.png content/docs/reference/
cp ${DEPS}/_/escape/vendor/github.com/ankyra/escape-core/docs/generated/*.md content/docs/reference/
cp ${DEPS}/_/escape/vendor/github.com/ankyra/escape-core/docs/*.md content/docs/reference/
cp ${DEPS}/_/escape-inventory/docs/*.md content/docs/reference/

hugulp build

if [ -z $SKIP_BUILD ] ; then 
    deps/_/extension-docker-kubespec/build.sh $@
fi
