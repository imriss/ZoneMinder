#!/bin/bash
d=${BUILDDIR:-$PWD}
echo "${BUILDDIR:-$PWD}"
for p in ${@##-*}
do
cd "$d"
echo "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" 
curl "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" |tar xz
cd "$p"
echo "makepkg --skippgpcheck ${@##[^\-]*}"
makepkg --skippgpcheck ${@##[^\-]*}
echo "$d"
# /usr/sbin/find / -name "$p.*" 
# ls -laR "$d"
# su root -c 'pacman -U $p.tar.xz'
done
