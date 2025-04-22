#!/bin/sh

[ -z "$1" ] && echo "Usage: $0 PROFILE_NAME" && exit 1

static=static-$1
link=$1
volatile=/dev/shm/firefox-$1-$USER

IFS=
set -efu

cd ~/.mozilla/firefox

if [ ! -r $volatile ]; then
	mkdir -m0700 $volatile
fi

if [ "$(readlink $link)" != "$volatile" ]; then
	mv $link $static
	ln -s $volatile $link
fi

if [ -e $link/.unpacked ]; then
	echo 'Backing up profile to the static folder...'
	rsync -av --delete --exclude .unpacked ./$link/ ./$static/
else
	echo 'Copying profile to tmpfs folder...'
	rsync -av ./$static/ ./$link/
	touch $link/.unpacked
fi
