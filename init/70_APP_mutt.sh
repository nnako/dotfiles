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

# this configuration changes mutt to use a local mail directory and does not
# fetch mail from any remote location

set mbox_type = Maildir
set folder    = "~/Mail"

# configure default account settings
source ~/.config/mutt/accounts/prive




#
# EDITOR
#

# choose application
set editor=vim

# enable change of HEADER in editor
set use_from
set edit_headers=yes

# get default FROM from original email
set reverse_name




#
# DISPLAY AND GENERAL DESIGN
#

# SIDEBAR configuration
source "/usr/share/doc/mutt/examples/sample.muttrc-sidebar"
mailboxes \
=NnamdiKohn/INBOX \
=Nnako/INBOX \
=Shopping \
=Einkommensteuer \
=Sent =Papierkorb

# default STATUSBAR configuration
set status_format="-%r-nnamdi.kohn@web.de: %f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?o? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l]---(%s/%S)-%>-(%P)---"




#
# IDENTITIES
#

# switch to NnamdiKohn
macro index <f3> \
"\
:set from=nnamdi.kohn@web.de<enter>\
:set status_format=\"-%r-nnamdi.kohn@web.de: %f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?o? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l]---(%s/%S)-%>-(%P)---\"<enter>\
:source ~/.config/mutt/accounts/prive<enter>\
<change-folder>!<enter>\
" \
"Switch to nnamdi.kohn@web.de"

# switch to Nnako
macro index <f4> \
"\
:set from=nnako@web.de\n\
:set status_format=\"-%r-nnako@web.de: %f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?o? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l]---(%s/%S)-%>-(%P)---\"\n\
:source ~/.config/mutt/accounts/nnako\n\
<change-folder>!<enter>\
" \
"Switch to nnako@web.de"

# hook identities on folder switch
#
# the files contain mailbox settings
# as well as color settings for the
# display within mutt
#
folder-hook NnamdiKohn/* source ~/.config/mutt/accounts/prive
folder-hook Nnako/*      source ~/.config/mutt/accounts/nnako




#
# KEYBOARD BINDINGS
#

# https://rlue.github.io/posts/2017-05-21-mutt-the-vim-way

bind generic             z         noop
bind index,pager,attach  g         noop
bind index,pager         d         noop
bind index,pager         s         noop
bind index,pager         c         noop
bind generic,pager       t         noop

# moving and scrolling
bind generic,index,pager \Cf       next-page
bind generic,index,pager \Cb       previous-page
bind generic             gg        first-entry
bind generic,index       G         last-entry
bind pager               gg        top
bind pager               G         bottom
bind generic,pager       \Cy       previous-line
bind generic,index,pager \Ce       next-line
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

# delete
bind pager,index         dT        delete-thread
bind pager,index         dt        delete-subthread
macro index,pager        dd  "<delete-message><sync-mailbox>"                                 "move message to trash"
macro index,pager        dat "<delete-thread><sync-mailbox>"                                  "move thread to trash"

# Go to folder...
macro index,pager        gi "<change-folder>=INBOX<enter>"       "open inbox"
macro index,pager        gd "<change-folder>=Drafts<enter>"      "open drafts"
macro index,pager        gs "<change-folder>=Sent<enter>"        "open sent"
#macro index,pager        gt "<change-folder>$trash<enter>"       "open trash"
macro index,pager        gf "<change-folder>?"                   "open mailbox..."

# Actions
macro index,pager        ss  ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<save-message>?"                                                                                                                                     "save message to a mailbox"
macro index              sat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015\"\015<mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix-cond><save-message>?"                                    "save thread to a mailbox"
macro index              \;s ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<tag-prefix-cond><save-message>?"                                                                                                                    "save tagged messages to a mailbox"
macro pager              sat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015<display-message>\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015<display-message>\"\015<exit><mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix><save-message>?" "save thread to a mailbox"
macro index,pager        cc  ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<copy-message>?"                                                                                                                                     "copy message to a mailbox"
macro index              cat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015\"\015<mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix-cond><copy-message>?"                                    "copy thread to a mailbox"
macro index              \;c ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015\"\015<tag-prefix-cond><copy-message>?"                                                                                                                    "copy tagged messages to a mailbox"
macro pager              cat ":macro browser \\015 \"\<select-entry\>\<sync-mailbox\>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015<display-message>\"\015:macro browser q \"<exit>:bind browser \\\\015 select-entry\\015:bind browser q exit\\015'q<untag-pattern>.\\015<display-message>\"\015<exit><mark-message>q<enter><untag-pattern>.<enter><tag-thread><tag-prefix><copy-message>?" "copy thread to a mailbox"
bind  generic            tt  tag-entry
bind  index              tat tag-thread
bind  pager              tt  tag-message
macro pager              tat "<exit><mark-message>q<enter><tag-thread>'q<display-message>"    "tag-thread"
macro index,pager        gx  "<pipe-message>urlview<Enter>"                                   "call urlview to extract URLs out of a message"
macro attach,compose     gx  "<pipe-entry>urlview<Enter>"                                     "call urlview to extract URLs out of a message"

# Command Line
bind editor \Cp history-up
bind editor \Cn history-down




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

# create script
FILEPATH=~/bin/checkmail.sh
cat > ${FILEPATH} <<EOF
#!/bin/sh

STATE=`nmcli networking connectivity`

if [ $STATE = 'vollständig' ]
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

