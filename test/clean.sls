{#
 This state take a salt-minion and remove all debian packages that aren't
 required to run only it.
 Useful to identify if dependencies are missing.
#}

{#
 You can't uninstall sudo, if no root password
 #}
user_root:
  user:
    - present
    - name: root
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
      - eject
      - fonts-ubuntu-font-family-console
      - friendly-recovery
      - ftp
      - fuse
      - fuse-utils
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
    - require:
      - user_root

deborphan:
  pkg:
    - installed
