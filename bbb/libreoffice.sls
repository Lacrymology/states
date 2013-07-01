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
  apt_repository:
    - present
    - address: http://ppa.launchpad.net/libreoffice/libreoffice-4-0/ubuntu
    - components:
      - main
    - distribution: {{ grains['lsb_codename'] }}
    - key_id: 1378B444
    - key_server: keyserver.ubuntu.com
  pkg:
    - installed
    - require:
      - apt_repository: libreoffice
      - pkg: openjdk_jre_headless
