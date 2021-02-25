# after installation, the application can be used by typing
# "r2 <options>" into the command line. the application will
# be installed system-wide.




#
# set source code path settings
#

prjname="APP__radare2"
prjpath="https://github.com/radareorg/radare2.git"




#
# clone source code
#

if [[ ! -d "$HOME/$prjname" ]]; then
    git clone $prjpath $HOME/$prjname
fi




#
# install application from source
#

cd $HOME/$prjname
sys/install.sh




#
# get and install relevant packages (if not already present)
#

# ...




#
# create virtual environment for project
#

# ...




#
# prepare project folders and get sources
#

# ...

