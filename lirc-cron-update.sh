#!/bin/bash
#
# Mirror the remotes dir, create remotes.{list,yaml} + remotes-table.html
# and upload these. You need to update SF_USER (in script or environment)
# and have setup automated sf ssh login.
#
# Environment:
# SF_USER:  sourceforge user name, needs to be able to make ssh
#           operations without a password.
# WORK_DIR: Working directory, must exist and be writable
# LOG_DIR:  Log directory, must exist and be writable
# BRANCH:   Git branch to pull

readonly SF_USER=${SF_USER:-'alec_leamas'}
readonly LOG_DIR=${LOG_DIR:-'/var/log/lirc-cron-update'}
readonly WORK_DIR=${WORK_DIR:-'/usr/local/var/lirc-remotes'}
readonly BASE_URL='https://sf.net/p/lirc-remotes/code/ci/master/tree/remotes'
readonly GIT_URL='git://git.code.sf.net/p/lirc/git'
readonly GIT_REMOTES_URL='git://git.code.sf.net/p/lirc-remotes/code'
readonly MARKDOWN="/usr/bin/markdown2-3.3 --extras=code-friendly"
readonly BRANCH='master'

function enumerate()
# Enumerates the remotes directory in $1  to # a simple csv list. Format is:
#
#     directory;lircd.conf;lircmd.conf;picture; names;timing;raw
#
# Directory and lircd.conf are always present. The rest is optional.
# The names part is the name header parameter for all remote defs
# in the lircd.conf file.
#
{
        lirc-lsremotes $1
}


function make_dir()
#
# Create a directory in yaml syntax, used for browsing
#
{

    echo "remotes:"
    lastdir="foobar"

    local oldifs="$IFS"
    IFS=';'
    while read dir lircd lircmd photo name timing raw; do
        [[ $dir != "$lastdir" ]] && echo "    $dir:"
        lastdir=$dir
        if [[ $photo == no* ]] ; then
            photo=""
        fi
        echo "       $dir/$name: $photo"
    done
    IFS=$oldifs
}


function pickle()
# Convert remotes.yaml to a python pickle stream.
{
/usr/bin/env python3 << EOF
import pickle
import yaml
import sys
import os
with open("$1") as f:
    y = yaml.load(f)
with os.fdopen(1, "wb") as f:
    pickle.dump(y, f)
EOF
}


function make_table()
#
# Build a html table from the remotes.list produced by enumerate.sh
#
{
    remotes_list=$1
    head=$2
    foot=$3

    cat $head
    echo '<table border="0">
        <tr>
            <th>&nbsp</th>
            <th>lircd.conf file</th>
            <th>&nbsp</th>
            <th>Supported remotes</th>
            <th>Timing</th>
            <th>Raw</th>
            <th>lircmd.conf</th>
       </tr>'


    local oldifs="$IFS"
    IFS=';'
    while read dir lircd lircmd photo names timing raw; do
        echo '<tr>'
        echo "<td><a href=\"$BASE_URL/$dir\">
                   <img src="../html/folder.png"></a></td>"
        echo "<td><a href=\"$BASE_URL/$dir/$lircd\">$dir/$lircd</a></td>"
        if [[ -n "$photo" && "$photo" != 'no_photo' ]]; then
            echo "<td><a href=\"$BASE_URL/$dir/$photo\">
		      <img src="../html/image.png"></a></td>"
        else
            echo "<td>&nbsp</td>"
        fi
        if [ -n "$names" ]; then
            echo "<td>$names</td>"
        else
            echo "<td>&nbsp</td>"
        fi
        if [[ $timing == no* ]]; then
            echo "<td><img src="../html/no.png"></td>"
        else
            echo "<td><img src="../html/yes.png"></td>"
        fi
        if [[ $raw == no* ]]; then
            echo "<td> No </td>"
        else
            echo "<td> Yes </td>"
        fi
        if [[ "$lircmd" != 'no_lircmd' ]]; then
            echo "<td><a href=\"$BASE_URL/$dir/$lircmd\">$lircmd</a></td>"
        else
            echo "<td>&nbsp</td>"
        fi
    done < $remotes_list
    IFS=$oldifs
    echo '</table>'
    cat $foot | \
         sed '/ast update:/s/.*/'"Last update: $(date +'%Y-%m-%d %H:%m')/"
}


# Setup
exec >$LOG_DIR/job.log 2>&1
date
cd $WORK_DIR

# Clone sources to current dir
if [ -d lirc-remotes ]; then
    cd lirc-remotes
    git pull
    cd $OLDPWD
else
    git clone ${BRANCH:+'-b'} $BRANCH $GIT_REMOTES_URL lirc-remotes
fi

# Create remotes.list, remotes.yaml/pickle and remotes-table.html
startdir=$PWD
cd lirc-remotes
enumerate remotes | iconv -f iso-8859-1 -t utf-8 > db/remotes.list
make_dir < db/remotes.list > db/remotes.yaml
pickle  db/remotes.yaml > db/remotes.pickle
make_table db/remotes.list  html/head.html html/foot.html \
    > db/remotes-table.html

set -x
cd $startdir/lirc-remotes

$MARKDOWN index.md > index.html

# Upload to sourceforge
sftp $SF_USER@web.sourceforge.net << EOF
cd /home/project-web/lirc-remotes/htdocs
put db/remotes-table.html
put db/remotes.pickle
put db/remotes.list
put db/remotes.yaml
put -r html
put index.html
quit
EOF

echo "Job completed at $(date)"
