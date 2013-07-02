libreoffice:
  {#
  apt_repository:
    - present
    - address: http://ppa.launchpad.net/libreoffice/libreoffice-4-0/ubuntu
    - components:
      - main
    - distribution: {{ grains['lsb_codename'] }}
    - key_id: 1378B444
    - key_server: keyserver.ubuntu.com
    #}
  pkg:
    - purged
  file:
    - name: /etc/apt/sources.list.d/ppa.launchpad.net-libreoffice_libreoffice-4-0_ubuntu-precise.list
    - absent

ffmpeg_build:
  pkg:
    - purged
    - pkgs:
      - build-essential
      - git-core
      - checkinstall
      - yasm
      - texi2html
      - libopencore-amrnb-dev
      - libopencore-amrwb-dev
      - libsdl1.2-dev
      - libtheora-dev
      - libvorbis-dev
      - libx11-dev
      - libxfixes-dev
      - libxvidcore-dev
      - zlib1g-dev

{% set ffmpeg_dir = "/usr/local/src/ffmpeg-0.11.2" %}
ffmpeg:
  file:
    - absent
    - name: {{ ffmpeg_dir }}

  cmd:
    - run
    - cwd: {{ ffmpeg_dir }}
    - name: ./configure  --enable-version3 --enable-postproc  --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis  --enable-libvpx && make && checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" --backup=no --deldoc=yes --default
    - unless: test -e {{ ffmpeg_dir }}/ffmpeg
    - require:
      - archive: ffmpeg
    - watch:
      - cmd: libvpx

libvpx:
  file:
    - absent
    - name: /usr/local/src/libvpx
    - require:
      - cmd: libvpx
  cmd:
    - run
    - name: make uninstall
    - cwd: /usr/local/src/libvpx

ruby_dependencies:
  pkg:
    - purged
    - pkgs:
      - libffi5
      - libreadline5

ruby1.9.2:
  pkg:
    - purged

{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
/usr/bin/{{ i }}:
  file:
    - absent
{% endfor %}

{#
bigbluebutton:
  pkgrepo:
    - managed
    - key_url: http://ubuntu.bigbluebutton.org/bigbluebutton.asc
    - name: deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-{{ grains['lsb_codename'] }} main
    - file: /etc/apt/sources.list.d/bigbluebutton.list
    #}
