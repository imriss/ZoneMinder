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
/usr/sbin/find / -name "$p.*" 2>/dev/null
ls -lar /home
# su root -c 'pacman -U $p.tar.xz'
done
