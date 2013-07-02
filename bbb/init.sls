include:
  - apt
  - java

language-pack-en:
  pkg:
    - installed

{{ salt['pillar.get']('encoding', 'en_US.UTF-8') }}:
  locale:
    - system
    - require:
      - pkg: language-pack-en

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

{% set ffmpeg_dir = "/usr/local/src/ffmpeg-0.11.2" %}
ffmpeg:
  archive:
    - extracted
    - name: /usr/local/src
    - source: http://ffmpeg.org/releases/ffmpeg-0.11.2.tar.gz
    - source_hash: md5=a6a86d54ffa81b9e1fc036a8d3a79a60
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ ffmpeg_dir }}
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
  cmd:
    - run
    - name: ./configure && make && make install
    - pwd: /usr/local/src/libvpx
    - unless: test -e /usr/local/src/libvpx/test_libvpx
    - require:
      - git: libvpx

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
      - pkg: libffi5

{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
/usr/bin/{{ i }}:
  file:
    - symlink
    - target: /usr/bin/{{ i }}1.9.2
    - require:
      - pkg: bigbluebutton_ruby

{% endfor %}

bigbluebutton:
  pkgrepo:
    - managed
    - key_url: http://ubuntu.bigbluebutton.org/bigbluebutton.asc
    - name: deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-{{ grains['lsb_codename'] }} main
    - file: /etc/apt/sources.list.d/bigbluebutton.list
  pkg:
    - installed
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
{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
      - symlink: /usr/bin/{{ i }}
{% endfor %}

