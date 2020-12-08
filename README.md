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
```
webdev [-h --help] [-v --verbose] [-l --launch=<number | bool>]
       [-f --fonts] [-j --java] [-i --js --javascript]
       [-p --py --python] [-r --ruby] <project-name>
```
Manually select which subdirectories to add to the project folder:
- `-f --fonts` - create a subdirectory for web fonts
- `-i --js --javascript` - create a subdirectory for javascript scripts
- `-j --java` - create a subdirectory for java scripts
- `-p --py --python` - create a subdirectory for Python scripts
- `-r --ruby` - create a subdirectory for ruby scripts

By default webdev launches an HTTP server on port 8000. Other options:
`-l=<number or bool> --launch=<number or bool>`
- `<number>`: pick an alternative port to launch on
- `true`: launch on port 8000 (default)
- `false`: do not launch HTTP server

Additional commands:
- `-v --verbose` - extended descriptive stdout
- `-h --help` - show help

## Supplementaty notes:
- Includes stylesheet for normalize v8.0.1
- Designed for and tested on Linux (MacOS).

## Ideas for additional features
- Pass number of default pages to include, other than index.html
- If verbose, echo files added (index.html, css/style.css)
- Add config to pass default author, language, etc. for HTML files (currently set up as me)
- Add a launch protocol option to choose to launch with Python, file path, etc.
