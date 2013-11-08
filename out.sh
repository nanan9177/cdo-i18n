#!/bin/bash

set -e

function cp_out() {
  echo "$1 => $2"
  cp $1 $2
}

locales=$(ls locales | grep -v 'en-US')

for locale in $locales; do

  js_locale=$(echo $locale | tr '[:upper:]' '[:lower:]' | tr '-' '_')

  ### Dashboard

  orig_dir=projects/dashboard/config/locales
  loc_dir=locales/$locale/dashboard

  # Special case the un-prefixed Yaml file.
  cp_out $loc_dir/base.yml $orig_dir/$locale.yml

  # Copy in all the other Yaml files.
  for file in $(find $loc_dir -name '*.yml' -and -not -name 'base.yml'); do
    relname=${file#$loc_dir}
    cp_out $file $orig_dir${relname%.yml}.${locale}.yml
  done


  ### Blockly Mooc

  orig_dir=projects/blockly-mooc/i18n
  loc_dir=locales/$locale/blockly-mooc

  # Copy JSON files.
  for file in $(find $loc_dir -name '*.json'); do
    relname=${file#$loc_dir}
    cp_out $file $orig_dir${relname%.json}/${js_locale}.json
  done


  ### Blockly Core
  orig_dir=projects/blockly-core/locales
  loc_dir=locales/$locale/blockly-core

  # Copy JSON files.
  for file in $(find $loc_dir -name '*.json'); do
    relname=${file#$loc_dir}
    cp_out $file $orig_dir$relname
  done


done

# Push translations to each sub project.
git submodule foreach git add .
git submodule foreach 'git commit --message=Translations --edit || true'
git submodule foreach git push origin master

# Commit submodules.
git add projects
git commit projects -m 'Updated submodules with latest translations'
git push origin master
