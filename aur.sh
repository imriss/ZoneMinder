#!/bin/bash
d=${BUILDDIR:-$PWD}
for p in ${@##-*}
do
cd "$d"
echo "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" 
curl "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" |tar xz
cd "$p"
echo "makepkg -V --skippgpcheck ${@##[^\-]*}"
makepkg -V --skippgpcheck ${@##[^\-]*}
echo "d"
ls -la
# su root -c 'pacman -U $p.tar.xz'
done
