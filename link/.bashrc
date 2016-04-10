#
## put DOTFILES variable into environment
#

export DOTFILES=~/.dotfiles

#
## add dotfiles' binaries into the path
#

PATH=$DOTFILES/bin:$PATH
export PATH

#
## define function to source all files in "source" folder
#

function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
  fi
}

#
## define function to run the dotfilles mechanism then source files
#

function dotfiles() {
  $DOTFILES/bin/dotfiles.sh "$@" && src
}

#
## source all files from "source"
#

src
