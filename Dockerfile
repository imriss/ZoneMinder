# ZoneMinder

FROM imriss/rarchlinux
MAINTAINER Reza Farrahi <imriss@ieee.org>

# Required packages 
RUN pacman -Syyu --noconfirm \
	&& pacman -S --needed --noconfirm wget \
	&& wget http://repo.archlinux.fr/x86_64/package-query-1.8-1-x86_64.pkg.tar.xz -O /tmp/package-query.tar.xz \
	&& pacman -U --noconfirm /tmp/package-query.tar.xz \	
	&& wget http://repo.archlinux.fr/x86_64/yaourt-1.8.1-1-any.pkg.tar.xz -O /tmp/yaourt.tar.xz \
	&& pacman -U --noconfirm /tmp/yaourt.tar.xz \
	&& pacman -S --needed --noconfirm polkit base-devel libmysqlclient openssl bzip2 \
	perl-dbi perl-date-manip perl-archive-zip perl-device-serialport \
	perl-mime-tools perl perl-dbd-mysql yasm cmake libjpeg-turbo \
	libtheora libvorbis libvpx libx264 libmp4v2 gst-libav mysql-clients apache php \
	mariadb vlc ffmpeg v4l-utils libtool netpbm perl-mime-lite patch 
RUN cd /tmp && yaourt --getpkgbuild aur/perl-sys-mmap && cd perl-sys-mmap && makepkg -sri USER root && ls -la \
	&& pacman -U --noconfirm /tmp/perl-sys-mmap/perl-sys-mmap-0.17-1-x86_64.pkg.tar.xz \
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

