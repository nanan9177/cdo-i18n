#!/bin/bash

set -e

locales=$(ls locales | grep -v 'en-US')

for locale in $locales; do

  js_locale=$(echo $locale | tr '[:upper:]' '[:lower:]' | tr '-' '_')

  ### Dashboard

  orig_dir=projects/dashboard/config/locales
  loc_dir=locales/$locale/dashboard
  en_dir=locales/en-US/dashboard

  # Special case the un-prefixed Yaml file.
  ruby ./lib/merge-translation.rb "yml" $en_dir/base.yml $loc_dir/base.yml $orig_dir/$locale.yml
  perl -i ./lib/fix-ruby-yml.pl $orig_dir/$locale.yml

  # Merge in all the other Yaml files.
  for file in $(find $loc_dir -name '*.yml' -and -not -name 'base.yml'); do
    relname=${file#$loc_dir}
    ruby ./lib/merge-translation.rb "yml" $en_dir$relname $file $orig_dir${relname%.yml}.${locale}.yml
    perl -i ./lib/fix-ruby-yml.pl $orig_dir${relname%.yml}.${locale}.yml
  done


  ### Blockly Mooc

  orig_dir=projects/blockly-mooc/i18n
  loc_dir=locales/$locale/blockly-mooc
  en_dir=locales/en-US/blockly-mooc

  # Copy JSON files.
  for file in $(find $loc_dir -name '*.json'); do
    relname=${file#$loc_dir}
    ruby ./lib/merge-translation.rb "json" $en_dir$relname $file $orig_dir${relname%.json}/${js_locale}.json
  done


  ### Blockly Core
  orig_dir=projects/blockly-core/locales/$locale
  loc_dir=locales/$locale/blockly-core
  en_dir=locales/en-US/blockly-core
  mkdir -p $orig_dir

  # Copy JSON files.
  for file in $(find $loc_dir -name '*.json'); do
    relname=${file#$loc_dir}
    ruby ./lib/merge-translation.rb "json" $en_dir$relname $file $orig_dir$relname
  done


  ### Pegasus
  orig_dir=projects/pegasus/sites/all/locales
  loc_dir=locales/$locale/pegasus
  en_dir=locales/en-US/pegasus

  # Merge YML file.
  ruby ./lib/merge-translation.rb "yml" $en_dir/mobile.yml $loc_dir/mobile.yml $orig_dir/$locale.yml
  perl -i ./lib/fix-ruby-yml.pl $orig_dir/$locale.yml


done


# Push translations to each sub project.
git submodule foreach git add .
git submodule foreach 'git commit --message=Translations --edit || true'
git submodule update --remote --rebase projects/*
for proj in $(ls projects); do
  proj_dir=projects/$proj
  branch=$(git config -f .gitmodules submodule.${proj_dir}.branch)
  (cd $proj_dir && git push origin HEAD:$branch)
done

# Commit submodules.
git add projects
git commit projects -m 'Updated submodules with latest translations'
git push origin master
