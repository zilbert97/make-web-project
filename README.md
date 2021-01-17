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
usage: mkweb [options] (<project-name> | <subcommand>)

ABOUT: –––––––––––––––––––––––––––––––––––
By default mkweb sets up a web development project folder with the following
file structure:

  ./<project-name>/
    +–– css/
    |   +–– style.css
    |
    +–– img/
    +–– index.html

OPTIONS: –––––––––––––––––––––––––––––––––
  -h, --help                     Print this usage information.
  -v, --verbose                  Print addition detail to stdout.

  -f, --fonts                    Create a subdirectory for web fonts.
  -i, --js, --javascript         Create a subdirectory for javascript scripts.
  -j, --java                     Create a subdirectory for java scripts.
  -p, --py, --python             Create a subdirectory for Python scripts.
  -r, --ruby                     Create a subdirectory for ruby scripts.
  -s, --sass, --scss             Create a subdirectory for Sass (.scss)
                                 scripts. Contents of the template .css file
                                 will be copied to scss/style.scss, with a
                                 blank stylesheet added at css/style.css.

  -b, --bootstrap                Include Bootstrap to the project. If you plan
                                 to use Bootstrap in your project we recommend
                                 passing this option as it defaults stylesheet
                                 names to 'custom' instead of 'style' to
                                 prevent conflicts.
  -n, --normalize                Include normalize.css in the project. Note
                                 is ignored if '--bootstrap' is also passed, as
                                 Bootstrap provides normalization built in.
  -l, --launch=<bool>|<number>   By default launches an HTTP server on port
                                 8000 from the root of the project directory.
                                 true: launch on port 8000 (default).
                                 false: do not launch HTTP server.
                                 <number>: pass the port number to launch on."
```

## Supplementaty notes:
- Includes stylesheet for normalize v8.0.1
- Designed for and tested on Linux (MacOS).

<hr>

## Next steps:
1. Update --verbose output (including "run sass scss:css" if --sass)
2. Modify help
3. Apply bootstrap - either add to index.html, or create another template with bootstrap included
4. Update README usage section with new features

## Ideas for additional features:
- Add a description to `show_help`
- Encourage modifying template file contents (note step 3^ "create another template with bootstrap included") - N.B. consider setting names of files in a config file that is `.gitignore`'d, so that pulls do not overwrite template files
- Pass number of default pages to include, other than index.html
- Add config to pass default author, language, etc. for HTML files (currently set up as me); and default launch protocol?
- Continue to allow `--launch` flag for one-line execution - but consider adding a `launch` subcommand so that you can start session through one command `mkweb launch` without needing to create a new project.
- Add a launch protocol option to choose to launch with Python, file path, etc. (e.g. `--launch-protocal=python`, `--launch-protocol=local`
- Change --launch so that if no param passed, default to true
- Include example use cases in README and --help
