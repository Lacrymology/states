{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

This state take a salt-minion and remove all debian packages that aren't
required to run only it.
Useful to identify if dependencies are missing.
-#}

include:
  - deborphan
  - kernel_modules
  - ttys

clean_pkg:
  pkg:
    - purged
    - pkgs:
      - accountsservice
      - acpid
      - anacron
      - apparmor
      - apparmor-utils
      - apport
      - apport-symptoms
      - apt-transport-https
      - apt-utils
      - apt-xapian-index
      - aptitude
      - at
      - bc
      - bind9-host
      - busybox-static
      - byobu
      - ca-certificates
      - cloud-init
      - cloud-initramfs-growroot
      - cloud-initramfs-rescuevol
      - cloud-utils
      - command-not-found
      - command-not-found-data
      - console-data
      - console-setup
      - cpp
      - cpp-4.6
      - cron
      - curl
      - dbus
      - dmidecode
      - dnsutils
      - dosfstools
      - dpkg-dev
      - ed
      - eject
      - euca2ools
      - fonts-ubuntu-font-family-console
      - friendly-recovery
      - ftp
      - fuse
      - fuse-utils
      - g++
      - gcc
      - geoip-database
      - gir1.2-glib-2.0
      - groff-base
      - hdparm
      - info
      - install-info
      - installation-report
      - iptables
      - iputils-ping
      - iputils-tracepath
      - irqbalance
      - iso-codes
      - iw
      - kbd
      - keyboard-configuration
      - krb5-locales
      - landscape-client
      - landscape-common
      - language-selector-common
      - laptop-detect
      - less
      - libapt-inst1.4
      - libclass-accessor-perl
      - libclass-isa-perl
      - libcurl3
      - libcurl3-gnutls
      - libdpkg-perl
      - liberror-perl
      - libio-string-perl
      - libjs-jquery
      - liblockfile-bin
      - libparse-debianchangelog-perl
      - libsub-name-perl
      - libswitch-perl
      - libtimedate-perl
      - libx11-data
      - locales
      - lockfile-progs
      - logrotate
      - lsb-release
      - lshw
      - lsof
      - ltrace
      - make
      - man-db
      - manpages
      - memtest86+
      - mlocate
      - mtr-tiny
      - nano
      - netcat-openbsd
      - ntfs-3g
      - ntpdate
      - openssh-client
      - openssh-server
      - openssl
      - os-prober
      - parted
      - patch
      - pciutils
      - perl
      - perl-modules
      - popularity-contest
      - powermgmt-base
      - ppp
      - pppconfig
      - pppoeconf
      - psmisc
      - python-apport
      - python-apt
      - python-apt-common
      - python-boto
      - python-chardet
      - python-cheetah
      - python-configobj
      - python-dbus
      - python-dbus-dev
      - python-debian
      - python-gdbm
      - python-gi
      - python-gnupginterface
      - python-httplib2
      - python-keyring
      - python-launchpadlib
      - python-lazr.restfulclient
      - python-lazr.uri
      - python-newt
      - python-oauth
      - python-openssl
      - python-pam
      - python-paramiko
      - python-problem-report
      - python-pycurl
      - python-serial
      - python-simplejson
      - python-software-properties
      - python-twisted-bin
      - python-twisted-core
      - python-twisted-names
      - python-twisted-web
      - python-wadllib
      - python-xapian
      - python-zope.interface
      - resolvconf
      - rsync
      - rsyslog
      - screen
      - sgml-base
      - ssh-import-id
      - strace
      - sudo
      - tasksel
      - tasksel-data
      - tcpd
      - tcpdump
      - telnet
      - time
      - tmux
      - ubuntu-minimal
      - ubuntu-minimal
      - ubuntu-standard
      - ubuntu-standard
      - ufw
      - unattended-upgrades
      - update-manager-core
      - update-notifier-common
      - ureadahead
      - usbutils
      - uuid-runtime
      - vim
      - vim-common
      - vim-runtime
      - vim-tiny
      - w3m
      - wget
      - whiptail
      - whoopsie
      - wireless-tools
      - wpasupplicant
      - xauth
      - xz-lzma
      - xkb-data
      - xml-core

{% for service in ('acpid', 'console-setup', 'dbus', 'whoopsie') %}
/var/log/upstart/{{ service }}.log:
  file:
    - absent
    - require:
      - pkg: clean_pkg
{% endfor %}

{%- for pkg in ('cloud-init', 'ufw') %}
/var/log/{{ pkg }}.log:
  file:
    - absent
    - require:
      - pkg: clean_pkg
{%- endfor -%}

{%- for file in ('/tmp/bootstrap-salt.log', '/var/lib/cloud', '/var/cache/apt-xapian-index') %}
{{ file }}:
  file:
    - absent
    - require:
      - pkg: clean_pkg
{%- endfor -%}

{%- if salt['cmd.has_exec']('deborphan') -%}
    {%- for pkg in salt['cmd.run']('deborphan').split("\n") -%}
        {%- if pkg != '' -%}
            {%- if loop.first %}
orphans:
  pkg:
    - purged
    - require:
      - pkg: clean_pkg
    - pkgs:
            {%- endif %}
      -  {{ pkg }}
        {%- endif -%}
    {%- endfor -%}
{%- endif -%}
