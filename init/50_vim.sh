# path settings
sPluginBasePath=$HOME/.vim/bundle # for pathogen plugin management




#
## install package
#

e_header "Installing Vim program file"

sudo apt-get install vim




#
## get plugins
#

e_header "Installing Vim Plugins"

# define plugin locations
lstPluginUrl=(
  https://github.com/MarcWeber/vim-addon-mw-utils.git
  https://github.com/tpope/vim-fugitive.git
  https://github.com/fidian/hexmode.git
  https://github.com/xolox/vim-session.git
  https://github.com/klen/python-mode.git
  https://github.com/vim-airline/vim-airline.git
  https://github.com/scrooloose/nerdcommenter.git
)

# strip plugin names from path
lstPluginName=""
for item in "${lstPluginUrl[@]}"; do
    sPluginName=$(basename $item)
    lstPluginName=(${lstPluginName[@]} "${sPluginName%%.*}")
done

# determine names of installed plugins if plugin folder already exists
if [[ -d $sPluginBasePath ]]; then

    # get path of plugins which have already been installed
    lstPluginPath_installed="$sPluginBasePath"/*

    # filter plugin names from path list
    lstPluginName_installed=""
    for item in ${lstPluginPath_installed[@]}; do

        sPluginName=$(basename $item)
        lstPluginName_installed=(${lstPluginName_installed[@]} "${sPluginName}")

    done

    # get only plugin names which are not already installed
    lstPluginName=($(setdiff "${lstPluginName[*]}" "${lstPluginName_installed[*]}"))

fi

## using each plugin name...
for sName in ${lstPluginName[@]}; do

    # for each listed url...
    for sUrl in ${lstPluginUrl[@]}; do

        # check if name is contained in url
        if [[ "$sUrl" == *"$sName"* ]]; then

            e_header "... " $sName

            # do the download
            git clone $sUrl $sPluginBasePath/$sName

            # proceed with next plugin name
            break

        fi

    done

done




#
## get configurations
#

e_header "Configuring Vim"
