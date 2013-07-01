{#
wget http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb
sudo dpkg -i openoffice.org_1.0.4_all.deb


sudo apt-get install python-software-properties

sudo apt-add-repository ppa:libreoffice/libreoffice-4-0
sudo apt-get update

sudo apt-get install libreoffice-common
sudo apt-get install libreoffice

#}
include:
  - apt
  - java


libreoffice:
  pkgrepo:
    - managed
    - ppa: wolfnet/logstash
    - keyid: 1378B444
    - keyserver: keyserver.ubuntu.com
    - file: /etc/apt/sources.list.d/libreoffice.list
  pkg:
    - installed
    - require:
      - pkgrepo: libreoffice
      - pkg: openjdk_jre_headless
