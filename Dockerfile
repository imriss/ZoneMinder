# ZoneMinder

FROM imriss/rarchlinux
MAINTAINER Reza Farrahi <imriss@ieee.org>

#
RUN ls /usr/share/ca-certificates/trust-source/anchors/ \
	&& cp /usr/share/ca-certificates/trust-source/anchors/CAcert.org_class3.crt /usr/share/ca-certificates/trust-source/anchors/CAcert.org_class3.pem \
	&& cp /usr/share/ca-certificates/trust-source/anchors/CAcert.org_root.crt /usr/share/ca-certificates/trust-source/anchors/CAcert.org_root.pem \	
	&& pacman -Syyu --noconfirm \
	&& pacman-db-upgrade 

#	&& wget https://archive.archlinux.org/repos/2016/12/21/core/os/x86_64/readline-7.0.001-1-x86_64.pkg.tar.xz -O /tmp/readline.tar.xz \
#	&& pacman -U --noconfirm /tmp/readline.tar.xz \
#	&& wget https://archive.archlinux.org/repos/2016/11/10/core/os/x86_64/readline-6.3.008-4-x86_64.pkg.tar.xz -O /tmp/readline.tar.xz \
#	&& pacman -U --noconfirm /tmp/readline.tar.xz \
#	&& wget https://archive.archlinux.org/repos/2016/12/21/core/os/x86_64/gnutls-3.4.17-1-x86_64.pkg.tar.xz -O /tmp/gnutls.tar.xz \
#	&& pacman -U --noconfirm /tmp/gnutls.tar.xz 
# bug (https://bbs.archlinux.org/viewtopic.php?id=223239)
RUN pacman -S --needed --noconfirm wget readline \
	&& wget https://archive.archlinux.org/repos/2016/12/21/core/os/x86_64/readline-7.0.001-1-x86_64.pkg.tar.xz -O /tmp/readline.tar.xz \
	&& pacman -U --noconfirm /tmp/readline.tar.xz \
	&& ln -s /usr/lib/libreadline.so.7 /usr/lib/libreadline.so.6 \
	&& pacman -S --force --noconfirm libgcrypt \
	&& pacman -S --force --noconfirm bash \
	&& wget https://archive.archlinux.org/repos/2016/12/21/core/os/x86_64/gnupg-2.1.16-2-x86_64.pkg.tar.xz -O /tmp/gnupg.tar.xz \
	&& pacman -U --noconfirm /tmp/gnupg.tar.xz 

	
	

RUN GNUPGHOME='/root/.gnupg' dirmngr -v --debug-level guru < /dev/null \
	&& ls -la  /usr/share/ca-certificates/trust-source/anchors \
	&& touch /root/.gnupg/dirmngr_ldapservers.conf \
	&& GNUPGHOME='/root/.gnupg' gpg -v --debug-level guru --debug 1024 --recv-keys --keyserver hkp://pgp.mit.edu:80 1D1F0DC78F173680 \
	&& GNUPGHOME='/root/.gnupg' gpg -v --debug-level guru --recv-keys --keyserver hkp://pgp.mit.edu:80 1EB2638FF56C0C53 \
	&& rm /usr/lib/libreadline.so.6 \
	&& pacman -Syyu --noconfirm 

# pacaur
# DDADD https://raw.githubusercontent.com/stuartpb/aur.sh/master/aur.sh /usr/sbin/aur.sh
# DDADD https://raw.githubusercontent.com/greyltc/docker-archlinux-aur/master/add-aur.sh /usr/sbin/add-aur
ADD ./aur.sh /usr/sbin/aur.sh
RUN chmod +x /usr/sbin/aur.sh
ADD ./add-aur.sh /usr/sbin/add-aur
RUN chmod +x /usr/sbin/add-aur
RUN add-aur docker

# Required packages 
ADD ./perl-sys-mmap.pkg.tar.xz /tmp/perl-sys-mmap.pkg.tar.xz
WORKDIR /tmp
RUN ls -la 
RUN pacman -U --noconfirm perl-sys-mmap.pkg.tar.xz
RUN pacman -S --needed --noconfirm wget \
	&& wget http://repo.archlinux.fr/x86_64/package-query-1.8-1-x86_64.pkg.tar.xz -O /tmp/package-query.tar.xz \
	&& pacman -U --noconfirm /tmp/package-query.tar.xz \	
	&& wget http://repo.archlinux.fr/x86_64/yaourt-1.8.1-1-any.pkg.tar.xz -O /tmp/yaourt.tar.xz \
	&& pacman -U --noconfirm /tmp/yaourt.tar.xz \
	&& pacman -S --needed --noconfirm polkit base-devel libmysqlclient openssl bzip2 \
	perl-dbi perl-date-manip perl-archive-zip perl-device-serialport \
	perl-mime-tools perl perl-dbd-mysql yasm cmake libjpeg-turbo \
	libtheora libvorbis libvpx libx264 libmp4v2 gst-libav mysql-clients apache php \
	mariadb vlc ffmpeg v4l-utils libtool netpbm perl-mime-lite patch \
	&& pacman -Scc --noconfirm

# Copy local code into our container
ADD . /ZoneMinder

# Change into the ZoneMinder directory
WORKDIR /ZoneMinder

# Setup the ZoneMinder build environment
#RUN aclocal && autoheader && automake --force-missing --add-missing && autoconf

# Configure ZoneMinder
#RUN ./configure --with-libarch=lib/$DEB_HOST_GNU_TYPE --disable-debug --host=$DEB_HOST_GNU_TYPE --build=$DEB_BUILD_GNU_TYPE --with-mysql=/usr  --with-webdir=/var/www/zm --with-ffmpeg=/usr --with-cgidir=/usr/lib/cgi-bin --with-webuser=www-data --with-webgroup=www-data --enable-mmap=yes --enable-onvif ZM_SSL_LIB=openssl ZM_DB_USER=zm ZM_DB_PASS=zm
RUN cmake .

# Build & install ZoneMinder
RUN make && make install

# ensure writable folders
RUN ./zmlinkcontent.sh

# Adding the start script
ADD utils/docker/start.sh /tmp/start.sh

# give files in /usr/local/share/zoneminder/
RUN chown -R www-data:www-data /usr/local/share/zoneminder/

# Adding apache virtual hosts file
ADD utils/docker/apache-vhost /etc/apache2/sites-available/000-default.conf
ADD utils/docker/phpdate.ini /etc/php5/apache2/conf.d/25-phpdate.ini

# Expose http ports
EXPOSE 80

# Initial database and apache setup:
RUN "/ZoneMinder/utils/docker/setup.sh"

CMD ["/ZoneMinder/utils/docker/start.sh"]

