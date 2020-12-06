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
- If verbose, echo files added (index.html, css/style.css)
- Add config to pass default author, language, etc. for HTML files (currently set up as me)

#### Handling default port ranges:
https://www.journaldev.com/34113/opening-a-port-on-linux
http://www.steves-internet-guide.com/tcpip-ports-sockets/

Thoughts:
- Do not allow ephemeral port (0-1023) *unless* forced (with an additional flag?)
- Take the port that is passed and check if free in user ports (1024-49151); if free then continue, else exit with message saying port is occupied and for user to choose another port or clear the port
- Remaining ports: dynamic ports (49152-65535); read into these, but suggest similar action to ephemeral ports
