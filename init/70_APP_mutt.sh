# https://whatsecurity.nl/using-mutt_offline.html




#
# install and configure mutt
#

# When you have a stable internet connection, such as in the office, Mutt is a
# pleasure to use. However, when there is no active internet connection, Mutt
# does not work well if you store all your email online. This is a guide to use
# Mutt offline, syncing all data when the internet connection is available
# again.

# install application
sudo apt-get update
sudo apt-get install mutt

# configure mutt to use LOCAL mail storage
FILEPATH=/home/pi/.config/mutt/muttrc
cat > ${FILEPATH} <<EOF

#
# MAILBOX
#

set sendmail="~/bin/msmtp-enqueue.sh"
set spoolfile="~/Mail/INBOX"
set folder="~/Mail"
set record="~/Mail/Sent"
set postponed="~/Mail/Drafts"
set mbox_type=Maildir




#
# EDITOR
#

set editor = vim




#
# NOTMUCH
#

macro index <F8> \
"<enter-command>set my_old_pipe_decode=\$pipe_decode my_old_wait_key=\$wait_key nopipe_decode nowait_key<enter>\
<shell-escape>notmuch-mutt -r --prompt search<enter>\
<change-folder-readonly>`echo ${XDG_CACHE_HOME:-$HOME/.cache}/notmuch/mutt/results`<enter>\
<enter-command>set pipe_decode=\$my_old_pipe_decode wait_key=\$my_old_wait_key<enter>i" \
"notmuch: search mail"

macro index <F9> \
"<enter-command>set my_old_pipe_decode=\$pipe_decode my_old_wait_key=\$wait_key nopipe_decode nowait_key<enter>\
<pipe-message>notmuch-mutt -r thread<enter>\
<change-folder-readonly>`echo ${XDG_CACHE_HOME:-$HOME/.cache}/notmuch/mutt/results`<enter>\
<enter-command>set pipe_decode=\$my_old_pipe_decode wait_key=\$my_old_wait_key<enter>" \
"notmuch: reconstruct thread"

macro index l "<enter-command>unset wait_key<enter><shell-escape>read -p 'notmuch query: ' x; echo \$x >~/.cache/mutt_terms<enter><limit>~i \"\`notmuch search --output=messages \$(cat ~/.cache/mutt_terms) | head -n 600 | perl -le '@a=<>;chomp@a;s/\^id:// for@a;$,=\"|\";print@a'\`\"<enter>" "show only messages matching a notmuch pattern"

EOF




#
# OFFLINEIMAP
#

# install application
sudo apt-get install offlinemap

# configure offlineimap
FILEPATH=~/.offlineimaprc
cat > ${FILEPATH} <<EOF

[general]
accounts = Prive

[Account Prive]
localrepository = PriveLocal
remoterepository = PriveRemote
status_backend = sqlite
postsynchook = notmuch new

[Repository PriveRemote]
type = IMAP
remotehost = imap.example.org
remoteuser = <username>
remotepass = <password>
ssl = yes
sslcacertfile = /etc/ssl/certs/ca-certificates.crt

[Repository PriveLocal]
type = Maildir
localfolders = ~/Maildir
restoreatime = no

EOF

# download email
offlineimap




#
# NOTMUCH
#

# install application
sudo apt-get install notmuch notmuch-mutt

# configure notmuch
notmuch setup

# index email database
notmuch new




#
# MSMTP
#

# install application
sudo apt-get install msmtp

# create configuration file
FILEPATH=~/.msmtprc
cat > ${FILEPATH} <<EOF

# Set default values for all following accounts.
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

account prive
host smtp.example.org
port 587

from user@example.org
auth on
user <username>
password <password>

account default: prive

EOF

# create executable files in local bin folder
mkdir ~/bin
cp /usr/share/doc/msmtp/examples/msmtpqueue/msmtp-enqueue.sh ~/bin/
cp /usr/share/doc/msmtp/examples/msmtpqueue/msmtp-runqueue.sh ~/bin/




#
# create auto check scripting
#

# install network manager
sudo apt install network-manager network-manager-gnome openvpn \
openvpn-systemd-resolved network-manager-openvpn \
network-manager-openvpn-gnome

# remove unnecessary packages
sudo apt purge openresolv dhcpcd5

# replace with symlink
sudo ln -sf /lib/systemd/resolv.conf /etc/resolv.conf

# create script
FILEPATH=~/bin/checkmail.sh
cat > ${FILEPATH} <<EOF
#!/bin/sh

STATE=`nmcli networking connectivity`

if [ $STATE = 'full' ]
then
    ~/bin/msmtp-runqueue.sh
    offlineimap
    exit 0
fi
echo "No internet connection."
exit 0

EOF

# make file executable
sudo chmod a+x ${FILEPATH}



#
# modify cron
#

#...

