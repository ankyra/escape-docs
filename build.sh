#!/bin/bash -e

rm -rf content/docs
mkdir -p content/
cp -r deps/_/escape-client/docs/cmd content/docs
cp deps/_/escape-client/docs/*.md content/docs/
cp deps/_/escape-client/vendor/github.com/ankyra/escape-core/docs/*.md content/docs/
cp deps/_/escape-registry/docs/*.md content/docs/

hugulp build

if [ -z $SKIP_BUILD ] ; then 
    deps/_/extension-docker-kubespec/build_and_apply.sh $@
fi
