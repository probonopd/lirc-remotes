#!/bin/bash
#
# Enumerates the remotes directory from lirc.org/remotes in
# a simple csv list. Format is:
#
#     directory;lircd.conf;lircmd.conf;picture; names...
#
# Directory and lircd.conf are always present. The rest is optional.
# The names part is the name header parameter for all remote defs
# in the lircd.conf file.
#

for dir in $( find . -maxdepth 1 -mindepth 1 -type d); do
    [[ $dir == *.git ]] && continue
    cd $dir
    for name in $(find . -type f); do
        name=${name#./}
        if [[ $name == lircd.conf.* ]]; then
            lircmd=$( ls ${name/lircd/lircmd} 2>/dev/null) || lircmd=""
            lircd=$name
	    photo=$(ls $name*.jpg 2>/dev/null) || photo=""
        elif [[ $name == *.* ]]; then
	    continue
        else
            lircd=$name
            lircmd=""
	    photo=$(ls $name*.jpg 2>/dev/null) || photo=""
        fi
        names=$(sed -nr '/begin +remote/, / begin /p' $lircd  \
                   | grep name | sed -r 's/name[ ]+//')
        echo "${dir#./};$lircd;$lircmd;$photo;"$names
    done
    cd $OLDPWD
done | sort -t';'  -k1

