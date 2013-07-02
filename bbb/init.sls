include:
  - apt
  - java
  - locale
  - ffmpeg

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

openoffice:
  pkg:
    - installed
    - sources:
      - openoffice.org: http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb

ruby_dependencies:
  pkg:
    - installed
    - pkgs:
      - libffi5
      - libreadline5

bigbluebutton_ruby:
  pkg:
    - installed
    - sources:
      - ruby1.9.2: https://bigbluebutton.googlecode.com/files/ruby1.9.2_1.9.2-p290-1_amd64.deb
    - require:
      - pkg: ruby_dependencies

{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
/usr/bin/{{ i }}:
  file:
    - symlink
    - target: /usr/bin/{{ i }}1.9.2
    - require:
      - pkg: bigbluebutton_ruby

{% endfor %}

{% set encoding = pillar['encoding']|default("en_US.UTF-8") %}
bigbluebutton:
  pkgrepo:
    - managed
    - key_url: http://ubuntu.bigbluebutton.org/bigbluebutton.asc
    - name: deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-{{ grains['lsb_codename'] }} main
    - file: /etc/apt/sources.list.d/bigbluebutton.list
  pkg:
    - installed
    - env:
        LANG: {{ encoding }}
        LC_ALL: {{ encoding }}
    - require:
      - pkgrepo: bigbluebutton
      - pkg: bigbluebutton_ruby
      - pkg: libreoffice
      - pkg: openoffice
      - archive: ffmpeg
{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
      - file: /usr/bin/{{ i }}
{% endfor %}

bbb-conf --setip {{ pillar['bbb:hostnames'][0] }}:
  cmd:
    - run
    - unless: grep -q {{ pillar['bbb:hostnames'][0] }} /var/www/bigbluebutton/client/conf/config.xml
    - require:
      - pkg: bigbluebutton
