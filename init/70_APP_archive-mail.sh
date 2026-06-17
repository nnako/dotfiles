
sudo apt -y update

# name of private project
prjname="APP__archive-mail"




#
# install application
#

# utility to transform maildir emails into human-readable format
prjpath="nnako@192.168.1.90:/media/nnako/rootfs/home/pi/$prjname.git"

# get project source code (if not already present)
if [[ ! -d "$HOME/$prjname" ]]; then
    git clone $prjpath $HOME/$prjname
fi

# create symbolic link in user's bin folder
ln -s -f ~/$prjname/archive-mail.sh ~/bin/




#
# install helper applications
#

# utility to read / write INI files
sudo apt -y install crudini

# utilities to manually handle maildir mails
sudo apt -y install maildir-utils

# utility to trigger changed files in a folder
sudo apt -y install entr




#
# modify cron
#

# user instructions
echo ''
echo ''
echo '##############################'
echo ''
echo 'IN ORDER TO COMPLETELY SETUP EMAIL'
echo 'CHECK / SEND, PLEASE MAKE SURE MODIFY'
echo 'CRON TO DO THE FOLLOWING:'
echo ''
echo '# install automatisms for the archive-mail'
echo '# tool which checks for changes within project'
echo '# folders, then extracts text and attachments'
echo '# and stores them to another folder which should'
echo '# be connected to a file sync mechanism to be'
echo '# uploaded to another location'
echo ''
echo '@reboot cd ~/APP__archive-mail && ./setup_archive-mail.sh ../NEXTCLOUD/_TXT/_mail.ini >> ./reboot.log'
echo ''
echo '##############################'
echo ''
echo ''
