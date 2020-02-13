#!/bin/bash
set -e

echo "Running CSpell check"
npx cspell --config .ci/cspell.json 'content/**/*.md'
