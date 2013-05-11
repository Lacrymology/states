{#
 This state take a salt-minion and remove all debian packages that aren't
 required to run only it.
 Useful to identify if dependencies are missing.
#}

{#
 You can't uninstall sudo, if no root password
 #}
root:
  user:
    - present
    - shell: /bin/bash
    - home: /root
    - uid: 0
    - gid: 0
    - enforce_password: True
    {# password: root #}
    - password: $6$FAsR0aKa$JoJGdUhaFGY1YxNEBDc8CEJig4L2GpAuAD8mP9UHhjViiJxJC2BTm9vFceEFDbB/yru5dEzLGHAssXthWNvON.

clean_pkg:
  pkg:
    - purged
    - names:
      - accountsservice
      - acpid
      - apparmor
      - apparmor-utils
      - apport
      - apport-symptoms
      - apt-transport-https
      - apt-xapian-index
      - aptitude
      - at
      - bc
      - busybox-static
      - bind9-host
      - byobu
      - cloud-init
      - cloud-initramfs-growroot
      - cloud-initramfs-rescuevol
      - command-not-found
      - command-not-found-data
      - console-setup
      - dnsutils
      - ed
      - eject
      - fonts-ubuntu-font-family-console
      - friendly-recovery
      - ftp
      - fuse
      - fuse-utils
      - groff-base
      - hdparm
      - info
      - installation-report
      - iptables
      - iputils-ping
      - iputils-tracepath
      - irqbalance
      - iw
      - kbd
      - keyboard-configuration
      - landscape-client
      - landscape-common
      - language-selector-common
      - laptop-detect
      - libjs-jquery
      - lockfile-progs
      - lshw
      - lsof
      - ltrace
      - manpages
      - man-db
      - memtest86+
      - mtr-tiny
      - nano
      - netcat-openbsd
      - ntfs-3g
      - ntpdate
      - patch
      - popularity-contest
      - powermgmt-base
      - ppp
      - pppconfig
      - pppoeconf
      - python-apport
      - python-chardet
      - python-cheetah
      - python-configobj
      - python-pycurl
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
      - python-problem-report
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
      - rsync
      - screen
      - strace
      - sudo
      - tasksel
      - tasksel-data
      - tcpdump
      - telnet
      - time
      - tmux
      - ubuntu-minimal
      - ubuntu-standard
      - ufw
      - ubuntu-minimal
      - ubuntu-standard
      - unattended-upgrades
      - update-manager-core
      - update-notifier-common
      - usbutils
      - whoopsie
      - w3m
      - wireless-tools
      - wpasupplicant
      - xauth
      - xkb-data
      - ca-certificates
      - cloud-utils
      - cron
      - curl
      - dbus
      - dosfstools
      - dmidecode
      - euca2ools
      - geoip-database
      - install-info
      - iso-codes
      - krb5-locales
      - less
      - libclass-accessor-perl
      - libcurl3
      - libcurl3-gnutls
      - libio-string-perl
      - libparse-debianchangelog-perl
      - libsub-name-perl
      - libswitch-perl
      - libtimedate-perl
      - locales
      - logrotate
      - lsb-release
      - openssh-server
      - openssl
      - os-prober
      - parted
      - pciutils
      - perl-modules
      - perl
      - python-apt
      - python-apt-common
      - python-boto
      - rsyslog
      - sgml-base
      - ssh-import-id
      - tcpd
      - ureadahead
      - uuid-runtime
      - vim
      - vim-common
      - vim-runtime
      - vim-tiny
      - wget
      - whiptail
      - xml-core
    - require:
      - user: root

deborphan:
  pkg:
    - installed


