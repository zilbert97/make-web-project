#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

RED='\033[0;31m'     # For error warnings
YELLOW='\033[1;33m'  # For hints
GREY='\033[0;37m'    # For comments
CYAN='\e[0;36m'      # For directories
NC='\033[0m'         # Reset colour


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


port=8000
verbose=false
normalize=true
subdirs=("css" "img")

while :; do
  case $1 in

    # Subdirs to create

    -f|--fonts)                               # Add subdir for Fonts
      subdirs+=("fonts")
      ;;
    -j|--jv|--java)
      subdirs+=("java")                       # Add subdir for Java
      ;;
    -i|--js|--javascript)                     # Add subdir for JavaScript
      subdirs+=("js")
      ;;
    -p|--py|--python)                         # Add subdir for Python
      subdirs+=("py")
      ;;
    -r|--ruby)                                # Add subdir for Ruby
      subdirs+=("ruby")
      ;;

    # Launch simple HTTP server; default launch on port 8000

# CAUGHT BUG:
# -l without arg passed must be the last flag, anything else passed (such as the
# directory name) gets interpreted.

    -l|--launch)
      if [ -n "$2" ]; then
        port=$2
        shift
      else                                    # Handle if no value passed to "--launch"
        echo -e "${RED}WARNING: '--launch' requires a port number or bool.${NC}"
        exit 1
      fi
      ;;

    -l=?*|--launch=?*)
      port=${1#*=}                            # Assign everything after "="      
      if [[ "$port" == "true" ]]; then        # If "--launch=true", set as defualt 8000
        port=8000
      elif [[ "$port" == "false" ]]; then     # If "--launch=false", keep set as false
        :
      elif ! [[ "$port" =~ ^[0-9]+$ ]]; then  # If otherwise not a number, handle error
        echo -e "${RED}WARNING: '--launch' requires a port number or bool.${NC}"
        exit 1

      # Check port is in correct range

      elif (( port >= 0 && port <= 1023 )) || (( port >= 49152 && port <= 65535)); then
        while true; do        
          read -p $'\e[1;33mThe port you have chosen is not recommended - using a user port (in the range 1024-49151) is STRONGLY advised. Do you wish to continue? (y/N): \e[0m' yn
            case $yn in
            [Yy]* ) make install; break;;
            [Nn]* ) exit;;
            * ) echo -e "${YELLOW}Please answer yes or no.${NC}";;
          esac
       done

      elif (( port < 0 )) || (( port >= 65536 )); then
        echo -e "${RED}WARNING: Invalid port number."
        exit 1

      else                                    # Else port is a number; keep set as number
        :
      fi
      ;;

    -l=|--launch=)                            # Handle if empty "--launch"
      echo -e "${RED}WARNING: '--launch' requires a port number or bool.${NC}"
      exit 1
      ;;

    # Other flags

# CAUGHT BUG:
# -n without arg passed must be the last flag, anything else passed (such as the
# directory name) gets interpreted.

    -n|--normalize)
      if [ -n "$2" ]; then
        normalize=$2
        shift
      else
        echo -e "${RED}WARNING: '--normalize' requires a boolean value.${NC}"
        exit 1
      fi
      ;;

    -n=?*|--normalize=?*)                     # Handle the value passed
      normalize=${1#*=}                       # Assign everything after "="
      if [[ "$normalize" == "false" ]]; then  # If "--normalize=false", set normalize to false
        normalize=false
      elif [[ "$normalize" == "true" ]]; then # If "--normalize=true", keep set as true
        normalize=true
      else                                    # If otherwise not bool, handle error
        echo -e "${RED}WARNING: '--normalize' requires a boolean value.${NC}"
        exit 1
      fi
      ;;

    -n=|--normalize=)                         # Handle if empty "--normalize"
      echo -e "${RED}WARNING: '--normalize' requires a boolean value.${NC}"
      exit 1
      ;;

    -v|--verbose)                             # Set "verbose" to true, for extended stdout
      verbose=true
      ;;
    -h|--help)                                # Call a "show_help" function, then exit
      show_help
      exit 0
      ;;
    --)                                       # End of options
      shift
      break
      ;;
    -?*)                                      # Call a "show_help" function, then exit
      echo -e "${RED}Invalid option: -$OPTARG${NC}" >&2
      # show_help
      exit 1
      ;;
    *)                                        # Default case: if no more options, break out of the loop
      break
  esac
  shift
done


# If no name for project dir is passed, ask for name

if [ "$1" != "" ]; then
  project="$1"
else
  read -p "Enter the name for your new web project: " project
fi


# If directory already exists raise warning and exit with code 1

if [ -d $project/ ]; then
  echo -e "${RED}WARNING: That project already exists in the current working directory.\nPlease try again with a new project name.${NC}"
  exit 1
else
  for i in ${subdirs[@]}; do
    mkdir -p $project/$i
  done

  # If verbose, show the dirs, subdirs, and files created
  if $verbose; then
    echo -e "\nCreated the following subdirectories:\n  ${CYAN}${subdirs[@]}${NC}"
  fi

  # Copy template files to the working directory
  cp $DIR/index_template.html $project/index.html
  cp $DIR/stylesheet_template.css $project/css/style.css

  # Copy normalize CSS file
  if $normalize; then
    cp $DIR/normalize_template.css $project/css/normalize.css
  fi
  
  if $verbose; then
    echo -e "Included the following files:\n  index.html\n  css/style.css"
    if $normalize; then
      echo "  css/normalize.css"
    fi
    echo -e ""
  fi
fi

# Launch a Simple HTTP server on port 8000 for testing

if ! [[ "$port" == "false" ]]; then
  cd ./$project/

  pyversion=$(python -c 'import sys; print(sys.version_info.major)')
  if [ "$pyversion" == 3 ]; then
    python -m http.server $port &> /dev/null &
  else
    python -m SimpleHTTPServer $port &> /dev/null &
  fi

  open http://localhost:$port/

  if $verbose; then
    pid=$(lsof -t -i :$port -s TCP:LISTEN)                        # MANUALLY PERFORM: lsof -n -i :${port} | grep LISTEN
    echo -e "Launched a simple HTTP server on port 8000.\n\n${YELLOW}hint: if you're seeing an Error 404 response, try:\n
      kill -9 $pid ${GREY}# That number is the PID that port $port is running on${YELLOW}\n\nand then run:

      python3 -m http.server $port &> /dev/null &  ${GREY}# If running Python 3+${YELLOW}
      python -m SimpleHTTPServer $port  ${GREY}# If running Python 2${YELLOW}

      open http://localhost:$port/${NC}"
  fi
else
  if $verbose; then
    echo "No HTTP server has been launched."
  fi
fi

exit 0
