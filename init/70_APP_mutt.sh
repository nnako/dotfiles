



#
# install helpful tools
#

# follow links displayed within the mail text
sudo apt install urlview




#
# install the application
#

sudo apt-get update
sudo apt-get install mutt




#
# configure mutt for offline usage
#

# When you have a stable internet connection, such as in the office, Mutt is a
# pleasure to use. However, when there is no active internet connection, Mutt
# does not work well if you store all your email online. This is a guide to use
# Mutt offline, syncing all data when the internet connection is available
# again.

# https://whatsecurity.nl/using-mutt_offline.html

# configure mutt to use LOCAL mail storage
FILEPATH=/home/pi/.mutt/muttrc
cat > ${FILEPATH} <<EOF
#
# MAILBOX
#

# this configuration changes mutt to use a local mail directory and does not
# fetch mail from any remote location

set mbox_type = Maildir
set folder    = "~/Mail"

# configure default account settings
source ~/.mutt/accounts/nnamdi




#
# EDITOR
#

# choose application
set editor=`echo \$EDITOR`

# enable change of HEADER in editor
set use_from
set askcc                            # ask for Cc before opening editor
set edit_headers=yes                 # show header on top when edit email body

# get default FROM from original email
set reverse_name

# title for email replied to
set attribution="On %d, %n wrote:"

# view for forward
set forward_format="Fwd: %s"
set forward_decode



#
# DISPLAY AND GENERAL DESIGN
#

# INDEX view
set index_format="[%Z] %?X?A&-? %D  %-20.20F  %s"
#set sort_aux=reverse-last-date-received

# PAGER view

# SIDEBAR view
source "/usr/share/doc/mutt/examples/sample.muttrc-sidebar"

# switch off the SIDEBAR for now
set sidebar_visible=no

# default STATUSBAR configuration
set status_format="-%r-nnamdi.kohn@web.de: %f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?o? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l]---(%s/%S)-%>-(%P)---"




#
# DEFINE VISIBLE MAILBOXES
#

# the mailboxes are looked up within the ~/Mail/ folder and then
# added to the mailbox variable to be available within mutt

mailboxes \
`find ~/Mail/ -type d -name cur -printf '%h '`




#
# TOGGLE VIEW SETTINGS
#

source ~/.mutt/index_view__sort_threaded.rc
# and set key "<SHIFT> + <S>" to toggle to view_by_date



#
# IDENTITIES
#

# switch to NnamdiKohn
macro index <f3> \
"\
:set from=nnamdi.kohn@web.de<enter>\
:set status_format=\"-%r-nnamdi.kohn@web.de: %f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?o? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l]---(%s/%S)-%>-(%P)---\"<enter>\
:source ~/.mutt/accounts/nnamdi<enter>\
<change-folder>!<enter>\
" \
"Switch to nnamdi.kohn@web.de"

# switch to Nnako
macro index <f4> \
"\
:set from=nnako@web.de\n\
:set status_format=\"-%r-nnako@web.de: %f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?o? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l]---(%s/%S)-%>-(%P)---\"\n\
:source ~/.mutt/accounts/nnako\n\
<change-folder>!<enter>\
" \
"Switch to nnako@web.de"

# hook identities on folder switch
#
# the files contain mailbox settings
# as well as color settings for the
# display within mutt
#
folder-hook NnamdiKohn/* source ~/.mutt/accounts/nnamdi
folder-hook Nnako/*      source ~/.mutt/accounts/nnako




#
# FURTHER KEYBOARD BINDINGS
#

# https://rlue.github.io/posts/2017-05-21-mutt-the-vim-way

# disable some standard keys
bind generic             z         noop
bind index,pager,attach  g         noop
bind index,pager         d         noop
#bind index,pager         s         noop
bind index,pager         ss         save-message
bind index,pager         c         noop
bind generic,pager       t         noop

# moving and scrolling
#bind generic,index,pager \Cf       next-page
#bind generic,index,pager \Cb       previous-page
bind generic             gg        first-entry
bind generic,index       G         last-entry
bind pager               gg        top
bind pager               G         bottom
bind pager               j         next-line
bind pager               k         previous-line
#bind generic,pager       \Cy       previous-line
#bind generic,index,pager \Ce       next-line
bind generic,index,pager \Cd       half-down
bind generic,index,pager \Cu       half-up
bind generic             zt        current-top
bind generic             zz        current-middle
bind generic             zb        current-bottom
bind index               za        collapse-thread
bind index               zA        collapse-all
bind index,pager         N         search-opposite
bind index               <Backtab> previous-new-then-unread
bind pager,index         gt        next-thread
bind pager,index         gT        previous-thread

# compose
bind  index,pager        a         group-reply

# move message
#macro index,pager        ss  "<enter-command> macro browser \\015 \"\<select-entry\>\<sync-mailbox\><enter-command> bind browser \\\\015 select-entry\\015<enter-command> bind browser q exit\\015\"\015<enter-command> macro browser q \"<exit><enter-command> bind browser \\\\015 select-entry\\015<enter-command> bind browser q exit\\015\"\015<save-message>?"                                           "move message to a mailbox"
macro index              sat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015\"\015<mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix-cond><save-message>?"                                    "move thread to a mailbox"
#macro index              \;s ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<tag-prefix-cond><save-message>?"                                                                                                                    "move tagged messages to a mailbox"
macro pager              sat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015<display-message>\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015<display-message>\"\015<exit><mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix><save-message>?" "move thread to a mailbox"

# copy message
macro index,pager        cc  ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<copy-message>?"                                                                                                                                     "copy message to a mailbox"
macro index              cat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015\"\015<mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix-cond><copy-message>?"                                    "copy thread to a mailbox"
macro index              \;c ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<tag-prefix-cond><copy-message>?"                                                                                                                    "copy tagged messages to a mailbox"
macro pager              cat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015<display-message>\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015<display-message>\"\015<exit><mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix><copy-message>?" "copy thread to a mailbox"

# delete
bind pager,index         dT        delete-thread
bind pager,index         dt        delete-subthread
macro index,pager        dd        "<delete-message><sync-mailbox>"                                 "move message to trash"
macro index,pager        dat       "<delete-thread><sync-mailbox>"                                  "move thread to trash"

# Go to folder...
#macro index,pager        gi "<change-folder>=INBOX<enter>"         "open account-specific inbox"
macro index,pager        gd "<change-folder>~/Mail/Drafts<enter>"  "open global drafts"
macro index,pager        gs "<change-folder>~/Mail/Sent<enter>"    "open global sent"
#macro index,pager        gu "<change-folder>=Unbekannt<enter>"     "open account-specific unknown"
#macro index,pager        gt "<change-folder>$trash<enter>"         "open trash"
macro index,pager        gf "<change-folder>?"                     "open mailbox..."

# tagging
bind  generic            tt  tag-entry
bind  index              tat tag-thread
bind  pager              tt  tag-message
macro pager              tat "<exit><mark-message>q<enter><tag-thread>'q<display-message>"    "tag-thread"

# view message
macro index,pager        gx  "<pipe-message>urlview<Enter>"                                   "call urlview to extract URLs out of a message"
macro attach,compose     gx  "<pipe-entry>urlview<Enter>"                                     "call urlview to extract URLs out of a message"

# Command Line
bind editor              \Cp history-up
bind editor              \Cn history-down




#
# URLSCAN - handle URLs
#

macro index,pager \cb "<pipe-message> urlscan<Enter>" "call urlscan to extract URLs out of a message"
macro attach,compose \cb "<pipe-entry> urlscan<Enter>" "call urlscan to extract URLs out of a message"




#
# NOTMUCH
#

# These macros define search hotkeys for notmuch. F8 lets you enter a search
# query and F9 expands the message under your cursor into the entire thread
# from which it came. The regular hotkey ‘l’ (limit) is overridden here to
# provide functionality similar to F8. I’m not sure yet which is the better of
# the two options.

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
# URLSCAN
#

# application to enable following urls from within emails

# install application
sudo apt-get install urlscan




#
# OFFLINEIMAP
#

# install application
sudo apt-get install offlineimap

# configure offlineimap
FILEPATH=~/.offlineimaprc
cat > ${FILEPATH} <<EOF
[general]
accounts = nnamdi,nnako


# GENERAL

[Account nnamdi]
localrepository = NnamdiLocal
remoterepository = NnamdiRemote
#status_backend = sqlite
postsynchook = notmuch new

[Repository NnamdiRemote]
type = IMAP
remotehost = imap.1und1.de
remoteuser = <username>
remotepass = <password>
ssl = yes
sslcacertfile = /etc/ssl/certs/ca-certificates.crt

[Repository NnamdiLocal]
type = Maildir
localfolders = ~/Mail/NnamdiKohn
restoreatime = no


# NNAKO

[Account nnako]
localrepository = NnakoLocal
remoterepository = NnakoRemote
#status_backend = sqlite
postsynchook = notmuch new

[Repository NnakoRemote]
type = IMAP
remotehost = imap.web.de
remoteuser = <username>
remotepass = <password>
ssl = yes
sslcacertfile = /etc/ssl/certs/ca-certificates.crt

[Repository NnakoLocal]
type = Maildir
localfolders = ~/Mail/Nnako
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

account nnamdi
host smtp.1und1.de
port 587
from <from>
auto_from off
auth on
user <username>
password <password>

account nnako
host smtp.web.de
port 587
from <from>
auto_from off
auth on
user <username>
password <password>

account default: nnamdi
EOF

# restrict access
sudo chmod g-r ${FILEPATH}
sudo chmod o-r ${FILEPATH}

# create executable files in local bin folder
mkdir ~/bin
cp /usr/share/doc/msmtp/examples/msmtpqueue/msmtp-enqueue.sh ~/bin/
cp /usr/share/doc/msmtp/examples/msmtpqueue/msmtp-runqueue.sh ~/bin/




#
# create auto check scripting
#

# install network manager
sudo apt-get install network-manager
#sudo apt install network-manager network-manager-gnome openvpn \
#openvpn-systemd-resolved network-manager-openvpn \
#network-manager-openvpn-gnome

# remove unnecessary packages
#sudo apt purge openresolv dhcpcd5

# replace with symlink
#sudo ln -sf /lib/systemd/resolv.conf /etc/resolv.conf

# create CHECKMAIL script
FILEPATH=~/bin/checkmail.sh
cat > ${FILEPATH} <<EOF
#!/bin/sh

STATE=`curl -Is http://www.google.com | head -n 1 | grep "200" | wc -l`

if [ $STATE = '1' ]
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
# create RUNQUEUE script
#

FILEPATH=~/bin/msmtp-runqueue.sh
cat > ${FILEPATH} <<EOF
#!/usr/bin/env bash

QUEUEDIR="$HOME/.msmtpqueue"
LOCKFILE="$QUEUEDIR/.lock"
MAXWAIT=120

OPTIONS=$@

# wait for a lock that another instance has set
WAIT=0
while [ -e "$LOCKFILE" -a "$WAIT" -lt "$MAXWAIT" ]; do
	sleep 1
	WAIT="`expr "$WAIT" + 1`"
done
if [ -e "$LOCKFILE" ]; then
	echo "Cannot use $QUEUEDIR: waited $MAXWAIT seconds for"
	echo "lockfile $LOCKFILE to vanish, giving up."
	echo "If you are sure that no other instance of this script is"
	echo "running, then delete the lock file."
	exit 1
fi

# change into $QUEUEDIR
cd "$QUEUEDIR" || exit 1

# check for empty queuedir
if [ "`echo *.mail`" = '*.mail' ]; then
	echo "No mails in $QUEUEDIR"
	exit 0
fi

# lock the $QUEUEDIR
touch "$LOCKFILE" || exit 1

# process all mails
for MAILFILE in *.mail; do
	MSMTPFILE="`echo $MAILFILE | sed -e 's/mail/msmtp/'`"
	echo "*** Sending $MAILFILE to `sed -e 's/^.*-- \(.*$\)/\1/' $MSMTPFILE` ..."
	if [ ! -f "$MSMTPFILE" ]; then
		echo "No corresponding file $MSMTPFILE found"
		echo "FAILURE"
		continue
	fi
	msmtp $OPTIONS `cat "$MSMTPFILE"` < "$MAILFILE"
	if [ $? -eq 0 ]; then
		rm "$MAILFILE" "$MSMTPFILE"
		echo "$MAILFILE sent successfully"
	else
		echo "FAILURE"
	fi
done

# remove the lock
rm -f "$LOCKFILE"

exit 0

EOF

# make file executable
sudo chmod a+x ${FILEPATH}




#
# create ENQUEUE script
#

FILEPATH=~/bin/msmtp-enqueue.sh
cat > ${FILEPATH} <<EOF
#!/usr/bin/env bash

QUEUEDIR=$HOME/.msmtpqueue

# Set secure permissions on created directories and files
umask 077

# Change to queue directory (create it if necessary)
if [ ! -d "$QUEUEDIR" ]; then
	mkdir -p "$QUEUEDIR" || exit 1
fi
cd "$QUEUEDIR" || exit 1

# Create new unique filenames of the form
# MAILFILE:  ccyy-mm-dd-hh.mm.ss[-x].mail
# MSMTPFILE: ccyy-mm-dd-hh.mm.ss[-x].msmtp
# where x is a consecutive number only appended if you send more than one
# mail per second.
BASE="`date +%Y-%m-%d-%H.%M.%S`"
if [ -f "$BASE.mail" -o -f "$BASE.msmtp" ]; then
	TMP="$BASE"
	i=1
	while [ -f "$TMP-$i.mail" -o -f "$TMP-$i.msmtp" ]; do
		i=`expr $i + 1`
	done
	BASE="$BASE-$i"
fi
MAILFILE="$BASE.mail"
MSMTPFILE="$BASE.msmtp"

# Write command line to $MSMTPFILE
echo "$@" > "$MSMTPFILE" || exit 1

# Write the mail to $MAILFILE
cat > "$MAILFILE" || exit 1

# If we are online, run the queue immediately.
# Replace the test with something suitable for your site.
#ping -c 1 -w 2 SOME-IP-ADDRESS > /dev/null
#if [ $? -eq 0 ]; then
#	msmtp-runqueue.sh > /dev/null &
#fi

exit 0
EOF

# make file executable
sudo chmod a+x ${FILEPATH}




#
# create LISTQUEUE script
#

FILEPATH=~/bin/msmtp-listqueue.sh
cat > ${FILEPATH} <<EOF
#!/usr/bin/env bash

QUEUEDIR=$HOME/.msmtpqueue

for i in $QUEUEDIR/*.mail; do
	egrep -s --colour -h '(^From:|^To:|^Subject:)' "$i" || echo "No mail in queue";
	echo " "
done
EOF

# make file executable
sudo chmod a+x ${FILEPATH}






#
# modify cron
#

#...

