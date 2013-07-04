libreoffice:
  pkg:
    - purged
  file:
    - name: /etc/apt/sources.list.d/ppa.launchpad.net-libreoffice_libreoffice-4-0_ubuntu-precise.list
    - absent

bigbluebutton:
  pkg:
    - purged

/etc/apt/sources.list.d/bigbluebutton.list:
  file:
    - absent

/usr/local/bin/bbb-conf-wrap.sh:
  file:
    - absent
