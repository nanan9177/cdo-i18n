#!/bin/bash

set -e

function cp_in() {
  echo "$1 => $2"
  cp $1 $2
}


## Bring projects up to date.
git submodule init projects/*
git submodule foreach git checkout master
git submodule foreach git pull origin master
git add projects
git commit projects -m 'Updated submodules with latest sources'


### Dashboard

orig_dir=projects/dashboard/config/locales
loc_dir=locales/en-US/dashboard
mkdir -p $loc_dir

# Special case the un-prefixed Yaml file.
cp_in $orig_dir/en.yml $loc_dir/base.yml

# Copy in all the other Yaml files.
for file in $(find $orig_dir -name '*.en.yml'); do
  relname=${file#$orig_dir}
  cp_in $file $loc_dir${relname%.en.yml}.yml
done


### Blockly Mooc

orig_dir=projects/blockly-mooc/i18n
loc_dir=locales/en-US/blockly-mooc
mkdir -p $loc_dir

# Copy JSON files.
for file in $(find $orig_dir -name 'en_us.json'); do
  relname=${file#$orig_dir}
  cp_in $file $loc_dir${relname%/en_us.json}.json
done
