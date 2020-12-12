# make-web-project
Sets up and launches a web development project.

## Setup:
1. `git clone` this repo to your location of choice
2. `cd` into the cloned repo
3. Make sure the file is executable by running `chmod +x mkweb.sh`
4. Add the `mkweb` command to your shell profile - run the following at the command line:\
  *If Bash shell:*\
  `setup_mkweb="alias mkweb='$(pwd)/mkweb.sh'" ; echo $setup_mkweb >> ~/.bash_profile`\
  *or*\
  `setup_mkweb="alias mkweb='$(pwd)/mkweb.sh'" ; echo $setup_mkweb >> ~/.bashrc`\
  \
  *If Zsh shell:*\
  `setup_mkweb="alias mkweb='$(pwd)/mkweb.sh'" ; echo $setup_mkweb >> ~/.zschrc`
5. Restart your shell session (or alternatively `source` your user profile - e.g. `source ~/.bash_profile`)

## Usage:


## Supplementaty notes:
- Includes stylesheet for normalize v8.0.1
- Designed for and tested on Linux (MacOS).

<hr>

## Next steps:
1. Add --bootstrap, --normalize, --sass to help
2. Update --verbose output (including "run sass scss:css" if --sass)
3. Apply bootstrap - either add to index.html, or create another template with bootstrap included
4. Update README usage section with new features

## Ideas for additional features:
- Add a description to `show_help`
- Encourage modifying template file contents (note step 3^ "create another template with bootstrap included") - N.B. consider setting names of files in a config file that is `.gitignore`'d, so that pulls do not overwrite template files
- Pass number of default pages to include, other than index.html
- Add config to pass default author, language, etc. for HTML files (currently set up as me); and default launch protocol?
- Continue to allow `--launch` flag for one-line execution - but consider adding a `launch` command so that you can start session through one command `mkweb launch`?
- Add a launch protocol option to choose to launch with Python, file path, etc. (e.g. `--launch-protocal=python`, `--launch-protocol=local`
- Make all verbose into a single function call
- Change --launch so that if no param passed, default to true
