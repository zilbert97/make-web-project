# make-web-project

## Setup:
1. `git clone` this repo to your location of choice
2. `cd` into the cloned repo
3. Make sure the file is executable by running `chmod +x mkweb.sh`
4. Add `mkweb` command to your shell profile:
```
# If running bash:
setup_mkweb="alias mkweb='$(pwd)/mkweb.sh'" | echo $setup_mkweb >> ~/.bash_profile
# Or:
setup_mkweb="alias mkweb='$(pwd)/mkweb.sh'" | echo $setup_mkweb >> ~/.bashrc

# If running Zsh:
setup_mkweb="alias mkweb='$(pwd)/mkweb.sh'" | echo $setup_mkweb >> ~/.zschrc
```
5. Restart your shell session (or alternatively `source` your user profile - e.g. `source ~/.bash_profile`)

Designed for and tested on Linux (MacOS).

## Ideas for additional features
- Pass number of default pages to include, other than index.html
- Handle correct port ranges - https://www.sciencedirect.com/topics/computer-science/registered-port
- Include python2 support to launch SimpleHTTP web server (currently requires python3 executed with alias python)
- If verbose, echo files added (index.html, css/style.css)
- Add config to pass default author, language, etc. for HTML files (currently set up as me)
