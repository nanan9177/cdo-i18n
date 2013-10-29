# Code.org Community Internationalization

Code.org's various projects are translated by the community using Crowdin.

This project provides scripts for centralizing source assets to be localized,
synchronizing with Crowdin, and then re-integrated the localized assets back
in to their respective projects.


## Dependencies:

### crowdin-cli

Install the Ruby gem:

```bash
gem install crowdin-cli
```


## Syncing with Crowdin

Full process includes four verbs: "in", "up", "down", and "out".

```bash
# Gather files from each subproject and stores them in ./locales/en-US
./in.sh

# Validate before uploading
git status locales/en-US
git diff locales/en-US
git add .
git commit

# Upload to Crowdin
./up.sh

# ... time passses ...

# Download from Crowdin
./down.sh

# Validate after downloading
git status
# etc
git commit

# Push translated files out to each subproject.
./out.sh


```


## Sub-project Notes

Each project and file format has it's own idiosyncrasies that must be addressed
by the scripts in this project. Notes about these issues are collected here.

### Dashboard

- Rails-style YAML Files
- Locales in file names use `en-US` format. Note: Upper case with dash.
- Source strings use `en` language, not full `en-US` locale.
- The top-level key of the YAML remains stays 'en' after download.

### Blockly Mooc

- JSON files with a flat object mapping string keys to strings.
- Locales in file names use `en_us` format. Note: Lower case with underscore.
