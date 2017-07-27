#!/bin/bash -e

rm -rf content/docs/escape-client/
mkdir -p content/docs/
cp -r deps/_/escape-client/docs/cmd content/docs/escape-client
hugulp build
