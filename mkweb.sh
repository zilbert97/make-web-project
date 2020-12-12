#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

RED='\033[0;31m'     #-- For error warnings
YELLOW='\033[1;33m'  #-- For hints
GREY='\033[0;37m'    #-- For comments
CYAN='\e[0;36m'      #-- For directories
NC='\033[0m'         #-- Reset colour


function show_help () {
  echo -e "
  usage: mkweb [-h --help] [-v --verbose] [-l --launch=<number | bool>]
               [-f --fonts] [-j --java] [-i --js --javascript]
               [-p --py --python] [-r --ruby] <project-name>

  mkweb sets up a web development project folder with the following default file structure:

    <project-name>/
      +-- css/
      |   +-- style.css
      |
      +-- img/
      +-- index.html

  Manually select which subdirectories to add to the project folder:
    -f --fonts                    Create a subdirectory for web fonts
    -i --js --javascript          Create a subdirectory for javascript scripts
    -j --java                     Create a subdirectory for java scripts
    -p --py --python              Create a subdirectory for Python scripts
    -r --ruby                     Create a subdirectory for ruby scripts

  By default webdev launches an HTTP server on port 8000 (equal to "--launch=true"):
    -l --launch=<number or bool>  true: launch on port 8000 (default)
                                  false: do not launch HTTP server
                                  <number>: alternatively pick the port to launch on

  Additional commands:
    -v --verbose                  Extended descriptive stdout
    -h --help                     Show help
"
}

function show_verbose() {
  echo -e "Created the following subdirectories:"
  for i in "${subdirs[@]}"; do
    echo -e "  ${CYAN}${i}${NC}"
  done; echo ""

  echo -e "Included the following files:"
  for i in "${web_files[@]}"; do
    echo "  ${i}"
  done; echo ""

  if [[ $port != false ]]; then
    pid=$(lsof -t -i :$port -s TCP:LISTEN)  # MANUALLY PERFORM: lsof -n -i :${port} | grep LISTEN
    echo -e "Launched a simple HTTP server on port ${port}.

${YELLOW}Hint: ${NC}if you're seeing an Error 404 response, try:
>> ${YELLOW}kill -9 $pid ${GREY}# The PID that port $port is currently running on

${NC}And then run:
>> ${YELLOW}python3 -m http.server $port &> /dev/null &  ${GREY}# If running Python 3+${NC}
>> ${YELLOW}python -m SimpleHTTPServer $port  ${GREY}# If running Python 2${NC}

>> ${YELLOW}open http://localhost:$port/${NC}"
  else
    echo -e "No HTTP server has been launched."
  fi
}

# Default values
port=8000
verbose=false
include_normalize=false
include_bootstrap=false
include_sass=false

style_sheet="style"
subdirs=("css" "img")
web_files=()

# If no args passed, show help
if [ "$1" == "" ]; then
  show_help; exit 0
fi

while :; do
  case $1 in

    #-- Subdirs to create
    -f|--fonts)               #-- Add subdir for Fonts
      subdirs+=("fonts")
      ;;
    -j|--jv|--java)           #-- Add subdir for Java
      subdirs+=("java")
      ;;
    -i|--js|--javascript)     #-- Add subdir for JavaScript
      subdirs+=("js")
      ;;
    -p|--py|--python)         #-- Add subdir for Python
      subdirs+=("py")
      ;;
    -r|--ruby)                #-- Add subdir for Ruby
      subdirs+=("ruby")
      ;;

    -s|--sass|--scss)         #-- Add subdir for Sass
      touch err_log
      sass --version > /dev/null 2> err_log
      if [[ -s err_log ]]; then
        echo -e "${RED}WARNING: Sass doesn't appear to be installed on your system.\nPlease install Sass first, then try again.${NC}";
        rm -f err_log; exit 1
      else
        subdirs+=("scss")
        include_sass=true
        rm -f err_log
      fi
      ;;

    -b|--bootstrap)           #-- Include bootstrapping
      include_bootstrap=true
      style_sheet='custom'
      ;;

    -n|--normalize)           #-- Include normalization stylesheet
      include_normalize=true
      ;;

    #-- Launch simple HTTP server; default launch on port 8000
    -l*|--launch*)
      if [[ "$1" != *=* ]] || [[ "$1" == *= ]]; then
        shift
        echo "${RED}WARNING: '--launch' requires a port number or bool.${NC}"
        exit 1
      else
        port="${1#*=}"

        #-- Validate the port passed
        if [[ "$port" == "true" ]]; then
          port=8000
        elif [[ "$port" == "false" ]]; then
          port=false
        elif ! [[ "$port" =~ ^[0-9]+$ ]]; then
          echo -e "${RED}WARNING: '--launch' requires a port number or bool.${NC}"
          exit 1
        else
          if (( port >= 0 && port <= 1023 )) || (( port >= 49152 && port <= 65535)); then
            while true; do
              read -p $'\e[1;33mThe port you have chosen is not recommended - using a user port (in the range 1024-49151) is STRONGLY advised. Do you wish to continue? (y/N): \e[0m' yn
              case $yn in
                [Yy]* ) break;;  # THIS WAS 'make install; break;;'
                [Nn]* ) exit;;
                * ) echo -e "${YELLOW}Please answer yes or no.${NC}";;
              esac
            done
          fi
        fi
      fi
      ;;

    #-- Other arguments
    -v|--verbose)             #-- Set "verbose" to true, for extended stdout
      verbose=true
      ;;
    -h|--help)                #-- Call a "show_help" function, then exit
      show_help
      exit 0
      ;;

    --)                       #-- End of options
      shift
      break
      ;;
    -?*)                      #-- Call a "show_help" function, then exit
      echo -e "${RED}WARNING: '$1' is an invalid option.${NC}"
      show_help
      exit 1
      ;;
    *)                        #-- Default case: if no more options, break out of the loop
      break
  esac
  shift
done

# Set name of the project as the arg passed after flags.
# If directory already exists raise warning and exit with code 1
project="$1"
if [ -d $project/ ]; then
  echo -e "${RED}WARNING: That project already exists in the current working directory.\nPlease try again with a new project name.${NC}"
  exit 1
fi

# Create dirs for flags passed
for i in ${subdirs[@]}; do
  mkdir -p $project/$i
done

# Copy template HTML file to the working directory
cp $DIR/index_template.html $project/index.html
# If bootstrap, add bootstrap to head of HTML that has been copied
# Or use seperate template for bootstrap?
web_files+=("index.html")

# Copy template CSS file to the working directory (relevant subdir)
if ! $include_sass; then
  cp $DIR/stylesheet_template.css $project/css/$style_sheet.css
  web_files+=("css/${style_sheet}.css")
else
  cp $DIR/stylesheet_template.css $project/scss/$style_sheet.scss
  touch $project/css/$style_sheet.css
  web_files+=("css/${style_sheet}.css" "scss/${style_sheet}.scss")
fi

# Copy normalize CSS file only if not including bootstrap
if $include_normalize && ! $include_bootstrap; then
  cp $DIR/normalize_template.css $project/css/normalize.css
  web_files+=("css/normalize.css")
elif $include_normalize && $include_bootstrap; then
  echo -e "${YELLOW}Bootstrap includes normalization by default. '--normalize' ignored.${NC}"
fi

# If verbose output the dirs, subdirs, and files created to stdout
# if $verbose; then
#   echo -e "\nCreated the following subdirectories:\n  ${CYAN}${subdirs[@]}${NC}\n"
#   echo -e "Included the following files:\n  ${web_files[@]}\n"
# fi

# Validate if port not false, launch simple HTTP server
if [[ $port != false ]]; then
  cd ./$project/

  pyv=$(python -c 'import sys; print(sys.version_info.major)')
  if [[ $pyv == 3 ]]; then
    python -m http.server $port &> /dev/null &
  else
    python -m SimpleHTTPServer $port &> /dev/null &
  fi

  # If including 'sass --watch scss:css' it should go here

  open http://localhost:$port/
fi

if $verbose; then
  show_verbose
fi

exit 0
