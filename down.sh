#!/bin/bash

set -e

crowdin-cli download

# Rewrite locale keys in Yaml files to be quoted.
# Otherwise Norwegian's `no: 1` is parsed as `{false=>1}`.
for yml in $(find locales -name '*.yml' | grep -v en-US); do
  perl -i -pe 's/^([a-z]+(?:-[A-Z]+)?):(.*)/"\1":\2/g' $yml
done
