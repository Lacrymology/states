ffmpeg_build:
  pkg:
    - installed
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

ffmpeg:
  archive:
    - extracted
    - name: /usr/local/src
    - source: http://ffmpeg.org/releases/ffmpeg-0.11.2.tar.gz
    - source_hash: md5=a6a86d54ffa81b9e1fc036a8d3a79a60
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/ffmpeg-0.11.2
{% set ffmpeg_dir = "/usr/local/src/ffmpeg-0.11.2" %}
  cmd:
    - run
    - pwd: {{ ffmpeg_dir }}
    - name: ./configure  --enable-version3 --enable-postproc  --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis  --enable-libvpx && make && checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" --backup=no --deldoc=yes --default
    - unless: test -e {{ ffmpeg_dir }}/ffmpeg
    - require:
      - archive: ffmpeg
    - watch:
      - cmd: libvpx

libvpx:
  git:
    - latest
    - target: /usr/local/src/libvpx
    - name: http://git.chromium.org/webm/libvpx.git
    {# todo require #}
  cmd:
    - run
    - name: ./configure && make && make install
    - pwd: /usr/local/src/libvpx
    - unless: test -e /usr/local/src/libvpx/test_libvpx
    - require:
      - git: libvpx

libffi5:
  pkg:
    - installed

bigbluebutton_ruby:
  pkg:
    - installed
    - sources:
      - ruby1.9.2: https://bigbluebutton.googlecode.com/files/ruby1.9.2_1.9.2-p290-1_amd64.deb
    - require:
      - pkg: libffi5

bigbluebutton:
  pkgrepo:
    - managed
    - key_url: http://ubuntu.bigbluebutton.org/bigbluebutton.asc
    - name: deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-{{ grains['lsb_codename'] }} main
    - file: /etc/apt/sources.list.d/bigbluebutton.list

  pkg:
    - installed
    - require:
{% set encoding = pillar['encoding']|default("en_US.UTF-8") %}
    - env:
        LANG: {{ encoding }}
    - require:
      - pkgrepo: bigbluebutton
      - pkg: bigbluebutton_ruby
      - cmd: libvpx
      - cmd: ffmpeg
      - pkg: ffmpeg_build
      - pkg: libreoffice
