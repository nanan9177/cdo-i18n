#!/bin/bash

set -e

locales=$(ls locales | grep -v 'en-US')

for locale in $locales; do

  js_locale=$(echo $locale | tr '[:upper:]' '[:lower:]' | tr '-' '_')

  ### Dashboard

  orig_dir=projects/dashboard/config/locales
  loc_dir=locales/$locale/dashboard

  # Special case the un-prefixed Yaml file.
  cp $loc_dir/base.yml $orig_dir/$locale.yml

  # Copy in all the other Yaml files.
  for file in $(find $loc_dir -name '*.yml' -and -not -name 'base.yml'); do
    relname=${file#$loc_dir}
    cp $file $orig_dir${relname%.yml}.${locale}.yml
  done


  ### Blockly Mooc

  orig_dir=projects/blockly-mooc/i18n
  loc_dir=locales/en-US/blockly-mooc

  # Copy JSON files.
  for file in $(find $loc_dir -name '*.json'); do
    relname=${file#$loc_dir}
    cp $file $orig_dir${relname%.json}/${js_locale}.json
  done

done
