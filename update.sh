# !/bin/sh

tar cfvz remotes.tar.gz.new remotes
mv remotes.tar.gz.new remotes.tar.gz

tar c remotes|bzip2 -s >remotes.tar.bz2.new
mv remotes.tar.bz2.new remotes.tar.bz2

#mail -n -s "remotes.tar.bz2 was updated" service@zapway.de <<EOF
#EOF
ls -l remotes.tar.gz remotes.tar.bz2
