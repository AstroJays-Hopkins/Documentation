#!/bin/bash
set -e

HUGO_VER="v0.64.1"

# npm packages
npm install

# Hugo
git clone https://github.com/gohugoio/hugo.git
cd hugo
git fetch --all --tags
git checkout "tags/$HUGO_VER" -b "$HUGO_VER"
# install hugo using go. Needs Go version >=1.11
go install --tags extended
