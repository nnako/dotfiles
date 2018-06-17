#
# settings
#

sPluginBasePath=$HOME/.tmux/plugins
sTmuxConfigPath=$HOME/.tmux.conf




#
# set plugins to be installed
#

e_header "Installing and Configuring Tmux Plugins"

# define plugin locations
lstPluginUrl=(
  https://github.com/tmux-plugins/tpm.git
  https://github.com/tmux-plugins/tmux-resurrect.git
  https://github.com/tmux-plugins/tmux-copycat.git
)

# strip plugin names from path
lstPluginName=""
for item in "${lstPluginUrl[@]}"; do
    sPluginName=$(basename $item)
    lstPluginName=(${lstPluginName[@]} "${sPluginName%%.*}")
done




#
# determine plugins not yet installed
#

# CAUTION
# a subsequent run of this block will clear all existing plugins from the
# configuration file so that none of the existing plugins will be re-installed.
# in order to re-install any plugin, you have to remove the specific plugin
# folder from the ~/.tmux/plugins directory. no already existing plugins will
# be installed.

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




#
# create configuration file
#

echo '# List of plugins' > $sTmuxConfigPath

# using each plugin name...
for sName in ${lstPluginName[@]}; do

    # for each listed url...
    for sUrl in ${lstPluginUrl[@]}; do

        # check if name is contained in url
        if [[ "$sUrl" == *"$sName"* ]]; then

            e_header "... " $sName

            # do the download
            git clone $sUrl $sPluginBasePath/$sName

            # insert plugin name into configuration
            echo "set -g @plugin 'tmux-plugins/$sName'" >> $sTmuxConfigPath

            # proceed with next plugin name
            break

        fi

    done

done

# create ending line in configuration file
echo "" >> $sTmuxConfigPath
echo "# Initialize tmux plugin manager" >> $sTmuxConfigPath
echo "run '$sPluginBasePath/tpm/tpm'" >> $sTmuxConfigPath




#
# source tmux configuration file
#

tmux source-file $sTmuxConfigPath

