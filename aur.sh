#!/bin/bash
d=${BUILDDIR:-$PWD}
echo "${BUILDDIR:-$PWD}"
for p in ${@##-*}
do
cd "$d"
echo "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" 
curl "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz" |tar xz
cd "$p"
echo "makepkg -V --skippgpcheck ${@##[^\-]*}"
makepkg -V --skippgpcheck ${@##[^\-]*}
echo "$d"
find / -name "$p.tar*" 2>/dev/null
ls -la
# su root -c 'pacman -U $p.tar.xz'
done
