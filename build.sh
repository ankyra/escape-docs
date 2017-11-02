#!/bin/bash -e

rm -rf content/docs
mkdir -p content/
cp -r deps/_/escape/docs/cmd content/docs
cp deps/_/escape/docs/*.md content/docs/
cp deps/_/escape/vendor/github.com/ankyra/escape-core/docs/*.md content/docs/
cp deps/_/escape-inventory/docs/*.md content/docs/

hugulp build

if [ -z $SKIP_BUILD ] ; then 
    deps/_/extension-docker-kubespec/build_and_apply.sh $@
fi
