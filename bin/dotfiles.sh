#!/usr/bin/env bash
[[ "$1" == "source" ]] || \

echo 'Dotfiles - nnako'

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP

Usage: $(basename "$0")

See the README for documentation.
https://github.com/nnako/dotfiles

Copyright (c) 2016 nnako
HELP
exit; fi




#
## define general purpose vars and functions
#

# Where the magic happens.
export DOTFILES=~/.dotfiles

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

# For testing.
function assert() {
  local success modes equals actual expected
  modes=(e_error e_success); equals=("!=" "=="); expected="$1"; shift
  actual="$("$@")"
  [[ "$actual" == "$expected" ]] && success=1 || success=0
  ${modes[success]} "\"$actual\" ${equals[success]} \"$expected\""
}

# OS detection
function is_osx() {
  [[ "$OSTYPE" =~ ^darwin ]] || return 1
}
function is_raspbian() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Raspbian ]] || return 1
}
function is_ubuntu() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}
function get_os() {
  for os in osx ubuntu raspbian; do
    is_$os; [[ $? == ${1:-0} ]] && echo $os
  done
}




#
## Remove an entry from $PATH
# Based on http://stackoverflow.com/a/2108540/142339
function path_remove() {
  local arg path
  path=":$PATH:"
  for arg in "$@"; do path="${path//:$arg:/:}"; done
  path="${path%:}"
  path="${path#:}"
  echo "$path"
}




#
## display a fancy multi-select menu.
# Inspired by http://serverfault.com/a/298312
function prompt_menu() {
  local exitcode prompt choices nums i n
  exitcode=0
  if [[ "$2" ]]; then
    _prompt_menu_draws "$1"
    read -t $2 -n 1 -sp "To edit this list, press any key within $2 seconds. "
    exitcode=$?
    echo ""
  fi 1>&2
  if [[ "$exitcode" == 0 ]]; then
    prompt="Toggle options (Separate options with spaces, ENTER when done): "
    while _prompt_menu_draws "$1" 1 && read -rp "$prompt" nums && [[ "$nums" ]]; do
      _prompt_menu_adds $nums
    done
  fi 1>&2
  _prompt_menu_adds
}

function _prompt_menu_iter() {
  local i sel state
  local fn=$1; shift
  for i in "${!menu_options[@]}"; do
    state=0
    for sel in "${menu_selects[@]}"; do
      [[ "$sel" == "${menu_options[i]}" ]] && state=1 && break
    done
    $fn $state $i "$@"
  done
}

function _prompt_menu_draws() {
  e_header "$1"
  _prompt_menu_iter _prompt_menu_draw "$2"
}

function _prompt_menu_draw() {
  local modes=(error success)
  if [[ "$3" ]]; then
    e_${modes[$1]} "$(printf "%2d) %s\n" $(($2+1)) "${menu_options[$2]}")"
  else
    e_${modes[$1]} "${menu_options[$2]}"
  fi
}

function _prompt_menu_adds() {
  _prompt_menu_result=()
  _prompt_menu_iter _prompt_menu_add "$@"
  menu_selects=("${_prompt_menu_result[@]}")
}

function _prompt_menu_add() {
  local state i n keep match
  state=$1; shift
  i=$1; shift
  for n in "$@"; do
    if [[ $n =~ ^[0-9]+$ ]] && (( n-1 == i )); then
      match=1; [[ "$state" == 0 ]] && keep=1
    fi
  done
  [[ ! "$match" && "$state" == 1 || "$keep" ]] || return
  _prompt_menu_result=("${_prompt_menu_result[@]}" "${menu_options[i]}")
}




#
## return words which are contained in A but not in B
#
#
# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B. Arrays in bash are insane
# (and not in a good way).
#
# From http://stackoverflow.com/a/1617303/142339
function setdiff() {
  local debug skip a b
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  if [[ "$1" ]]; then
    local setdiffA setdiffB setdiffC
    setdiffA=($1); setdiffB=($2)
  fi
  setdiffC=()
  for a in "${setdiffA[@]}"; do
    skip=
    for b in "${setdiffB[@]}"; do
      [[ "$a" == "$b" ]] && skip=1 && break
    done
    [[ "$skip" ]] || setdiffC=("${setdiffC[@]}" "$a")
  done
  [[ "$debug" ]] && for a in setdiffA setdiffB setdiffC; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
  done
  [[ "$1" ]] && echo "${setdiffC[@]}"
}

# If this file was being sourced, exit now.
[[ "$1" == "source" ]] && return




#
## define INIT functions
#

# Initialize.
init_file=$DOTFILES/caches/init/selected
function init_files() {
  local i f dirname oses os opt remove
  dirname="$(dirname "$1")"
  f=("$@")
  menu_options=(); menu_selects=()
  for i in "${!f[@]}"; do menu_options[i]="$(basename "${f[i]}")"; done
  if [[ -e "$init_file" ]]; then
    # Read cache file if possible
    IFS=$'\n' read -d '' -r -a menu_selects < "$init_file"
  else
    # Otherwise default to all scripts not specifically for other OSes
    oses=($(get_os 1))
    for opt in "${menu_options[@]}"; do
      remove=
      for os in "${oses[@]}"; do
        [[ "$opt" =~ (^|[^a-z])$os($|[^a-z]) ]] && remove=1 && break
      done
      [[ "$remove" ]] || menu_selects=("${menu_selects[@]}" "$opt")
    done
  fi
  prompt_menu "Run the following init scripts?" $prompt_delay
  # Write out cache file for future reading.
  rm "$init_file" 2>/dev/null
  for i in "${!menu_selects[@]}"; do
    echo "${menu_selects[i]}" >> "$init_file"
    echo "$dirname/${menu_selects[i]}"
  done
}
function init_do() {
  e_header "Sourcing $(basename "$2")"
  source "$2"
}




#
## define COPY functions
#

function copy_header() { e_header "Copying files into home directory"; }
function copy_test() {
  if [[ -e "$2" && ! "$(cmp "$1" "$2" 2> /dev/null)" ]]; then
    echo "same file"
  elif [[ "$1" -ot "$2" ]]; then
    echo "destination file newer"
  fi
}
function copy_do() {
  e_success "Copying ~/$1."
  cp "$2" ~/
}




#
## define LINK functions
#

function link_header() { e_header "Linking files into home directory"; }
function link_test() {
  [[ "$1" -ef "$2" ]] && echo "same file"
}
function link_do() {
  e_success "Linking ~/$1."
  ln -sf ${2#$HOME/} ~/
}




#
## manage different file types in folders
#

function do_stuff() {

  #
  ## list predeclared function and file names of appropriate folder
  #
  
  # get file name list from appropriate folder
  local base dest skip
  local files=($DOTFILES/$1/*)

  # append file name list to appropriate existing function "_files"
  # only applicable for INIT type activities
  [[ $(declare -f "$1_files") ]] && files=($($1_files "${files[@]}"))
  



  #
  ## abort if no files were found for appropriate folder
  #
  if (( ${#files[@]} == 0 )); then return; fi
  
  
  
  
  #
  ## run _header function of appropriate folder (only if declared)
  #
  [[ $(declare -f "$1_header") ]] && "$1_header"
  
  
  
  
  #
  ## iterate over file list and do the activity
  #
  
  for file in "${files[@]}"; do
  
    #
	## construct new path string for file found inside folder
	#
    base="$(basename $file)"
    dest="$HOME/$base"
	
	# if test function is declared
    if [[ $(declare -f "$1_test") ]]; then
	
      #
      ## run _test function of appropriate folder (only if declared)
      #

      # if _test function returns a string, skip file and print that message.
      skip="$("$1_test" "$file" "$dest")"
      if [[ "$skip" ]]; then
        e_error "Skipping ~/$base, $skip."
        continue
      fi
	  
      #
      ## back up already existing files
      #

      # if destination file already exists in ~/.
      if [[ -e "$dest" ]]; then
	  
        # echo message
        e_arrow "Backing up ~/$base."
		
        # Set backup flag, so a nice message can be shown at the end
        backup=1

        # create backup dir if it doesn't already exist
        [[ -e "$backup_dir" ]] || mkdir -p "$backup_dir"

        # backup file / link / whatever
        mv "$dest" "$backup_dir"
      fi
    fi

    #
    ## execute appropriate files from folders
	#
    "$1_do" "$base" "$file"

  done
}




# Enough with the functions, let's do stuff.




export prompt_delay=5

# Ensure that we can actually, like, compile anything.
if [[ ! "$(type -P gcc)" ]] && is_osx; then
  e_error "XCode or the Command Line Tools for XCode must be installed first."
  exit 1
fi




#
## install git if it is not installed
#

if [[ ! "$(type -P git)" ]] && is_ubuntu; then
  e_header "Installing Git"
  sudo apt-get -qq install git-core
fi
if [[ ! "$(type -P git)" ]] && is_raspbian; then
  e_header "Installing Git"
  sudo apt-get -qq install git-core
fi

# If Git isn't installed by now, something exploded. We gots to quit!
if [[ ! "$(type -P git)" ]]; then
  e_error "Git should be installed. It isn't. Aborting."
  exit 1
fi




#
## clone / update "dotfiles" from repo
#

# if dotfiles folder does not exist
if [[ ! -d $DOTFILES ]]; then

  # create folder and clone git repository
  new_dotfiles_install=1
  prompt_delay=15
  e_header "Downloading dotfiles"
  git clone --recursive git://github.com/${github_user:-nnako}/dotfiles.git $DOTFILES
  cd $DOTFILES

elif [[ "$1" != "restart" ]]; then

  # make sure we have the latest files.
  e_header "Updating dotfiles"
  cd $DOTFILES
  prev_head="$(git rev-parse HEAD)"
  git pull
  git submodule update --init --recursive --quiet
  if [[ "$(git rev-parse HEAD)" != "$prev_head" ]]; then
    e_header "Changes detected, restarting script"
    exec "$0" "restart"
  fi
fi




#
## adjust path variable and create additional folders
#

# add binary path
[[ -d $DOTFILES/bin ]] && PATH=$DOTFILES/bin:$PATH
export PATH

# Tweak file globbing.
shopt -s dotglob
shopt -s nullglob

# create caches dir and init subdir
mkdir -p "$DOTFILES/caches/init"

# if backups are needed, this is where they'll go.
backup_dir="$DOTFILES/backups/$(date "+%Y_%m_%d-%H_%M_%S")/"
backup=




#
## execute code for each file in the subdirectories
#

do_stuff "copy"
do_stuff "link"
do_stuff "init"

# Alert if backups were made.
if [[ "$backup" ]]; then
  echo -e "\nBackups were moved to ~/${backup_dir#$HOME/}"
fi

# All done!
e_header "All done!"
