#!/usr/bin/env bash
#/** 
#  * This script ...
#  * 
#  * Copyright (c) 2020 Christian Prior
#  * Licensed under the MIT License. See LICENSE file in the project root for full license information.
#  * 
#  * Usage: ...
#  * 
#  * @TODO: ...
#  * 
#  */


set -o nounset #exit on undeclared variable

__SCRIPTDIR=$(dirname "$0")
__REPODIR=${__SCRIPTDIR}/../../..
__SCRIPTNAME=$(basename "$0")
__VERBOSE=""                 #v
__SILENT="-s"                #v
__STARTCLEAN="false"         #c

__TEMP=$(mktemp /tmp/output.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }
trap "{ rm -f ${__TEMP}; }" EXIT

__usage() {
    cat << EOT
  Usage :  ${__SCRIPTNAME} [options]
  Examples:
    - ${__SCRIPTNAME}
    - ${__SCRIPTNAME} -a foo
    - ${__SCRIPTNAME} -b
    - ${__SCRIPTNAME} -a foo -b
  Options:
    -a  The option...
    -b  Also sets startclean to true
    -h  Display this message
EOT
}

while getopts ":a:bhv" opt; do
  case $opt in
    a) __OPTION1=$OPTARG                 ;;
    b) __OPTION2="true";
       __STARTCLEAN="true"
       ;;
    h) __usage; exit 0                  ;;
    v) __VERBOSE="-v"; __SILENT=""      ;;
    \?) echo "Invalid option -$OPTARG" >&2; echo -n "continuing "; sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo ".";
        ;;
  esac;
done

#http://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script
#The script needs root permissions to get the full output of \`lshw\`
# _SUDO=''
# if (( $EUID != 0 )); then
#     echo "This script needs root permissions to get the full output of \`lshw\`"
#     while true; do sudo lshw -quiet > ${__TEMP}; break; done
#   _SUDO='sudo'
# fi; #from now on this is possible: $SUDO some_command
# _SUDO='' #revert potential security hole until \`sudo\` is really needed further on


#Trying to keep this to a minimum.
#Script tested and developed on Ubuntu 18.04
checkrequirements() {
    echo -n "Checking requirements."
    i=0;
    type npm >/dev/null 2>&1 || { echo >&2 "This script requires npm but it is not installed. ";  i=$((i + 1)); }
    type chromium-browser >/dev/null 2>&1 || { echo >&2 "This script requires chromium-browser but it is not installed. ";  i=$((i + 1)); }

    echo "..done."
    if [[ $i > 0 ]]; then echo "Aborting."; echo "Please install the missing dependency."; exit 1; fi
} #end function checkrequirements


######################################################################
#/**
#  * Main part
#  *
#  */

#clear
echo -e "Something descriptive here...\n"
checkrequirements

cd $__REPODIR/biz/marketing/slides/reveal*

# todo: force kiosk when Chromium already running (instead of just new tab)
# https://peter.sh/experiments/chromium-command-line-switches/
$(sleep 6; chromium-browser --start-maximized --kiosk http://localhost:28001/ ) &
npm start -- --port=28001