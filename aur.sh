#!/bin/bash
d=${BUILDDIR:-$PWD}
for p in ${@##-*}
do
cd "$d"
echo "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" 
curl "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" |tar xz
cd "$p"
makepkg -V --skippgpcheck ${@##[^\-]*}
done
