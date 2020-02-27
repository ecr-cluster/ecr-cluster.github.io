#!/bin/bash

# we need to clear it to make sure we don't carry files with us
rm -rf public/*
hugo
pushd public
git add --all && git commit -m "Publishing to master"
popd
