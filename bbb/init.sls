{#-
Copyright (C) 2013 the Institute for Institutional Innovation by Data
Driven Design Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE  MASSACHUSETTS INSTITUTE OF
TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the names of the Institute for
Institutional Innovation by Data Driven Design Inc. shall not be used in
advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the
Institute for Institutional Innovation by Data Driven Design Inc.

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>
 -#}
{%- if grains['lsb_distrib_codename'] == 'lucid' %}
include:
  - apt
  - bbb.redis
  - ffmpeg
{% if grains['osrelease']|float < 12.04 %}
  - java.6
{% else %}
  - java.7
{% endif %}
  - local
  - locale
  - mscorefonts
  - nginx
  - redis
  - tomcat.6

libreoffice:
  apt_repository:
    - present
    - address: http://ppa.launchpad.net/libreoffice/libreoffice-4-0/ubuntu
    - components:
      - main
    - distribution: {{ grains['lsb_distrib_codename'] }}
    - key_id: 1378B444
    - key_server: keyserver.ubuntu.com
  pkg:
    - installed
    - require:
      - apt_repository: libreoffice
      - pkg: openjdk_jre_headless

{%- set openoffice_version = "1.0.4" %}
openoffice:
  pkg:
    - installed
    - sources:
  {%- if 'files_archive' in pillar %}
      - openoffice.org: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/openoffice.org_1.0.4_all.deb
  {%- else %}
      - openoffice.org: http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb
  {%- endif %}
{%- if salt['pkg.version']('openoffice.org') != version %}
      - pkg: openoffice_old_version

openoffice_old_version:
  pkg:
    - removed
    - name: openoffice.org
{%- endif %}

ruby_dependencies:
  pkg:
    - installed
    - pkgs:
      - libffi5
      - libreadline5
    - require:
      - cmd: apt_sources

{%- set bigbluebutton_ruby = "1.9.2" %}
{%- set bigbluebutton_ruby_sub_ver = "{0}-p290-1".format(vervion) %}
bigbluebutton_ruby:
  pkg:
    - installed
    - sources:
  {%- if 'files_archive' in pillar %}
      - ruby1.9.2: {{ pillar['files_archive']|replace('file://', '')|replace('https://', 'http://') }}/mirror/ruby1.9.2_{{ bigbluebutton_ruby_sub_ver }}_amd64.deb
  {%- else %}
      - ruby1.9.2: https://bigbluebutton.googlecode.com/files/ruby1.9.2_{{ bigbluebutton_ruby_sub_ver }}_amd64.deb
  {%- endif %}
    - require:
      - pkg: ruby_dependencies
{%- if salt['pkg.version']('ruby1.9.2') != bigbluebutton_ruby_sub_ver %}
      - pkg: bigbluebutton_ruby_old_version

bigbluebutton_ruby_old_version:
  pkg:
    - removed
    - name: ruby1.9.2
{%- endif %}

{%- for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
/usr/bin/{{ i }}:
  file:
    - symlink
    - target: /usr/bin/{{ i }}1.9.2
    - require:
      - pkg: bigbluebutton_ruby
    - require_in:
      - cmd: bigbluebutton
{%- endfor %}

{% set encoding = salt['pillar.get']('encoding', 'en_US.UTF-8') %}
bigbluebutton:
  cmd:
    - run
    - name: gem install builder bundler
    - env:
        LANG: {{ encoding }}
        LC_ALL: {{ encoding }}
    - unless: gem list --local | grep -q '^builder '
  pkgrepo:
    - managed
    - key_url: http://ubuntu.bigbluebutton.org/bigbluebutton.asc
    - name: deb http://ubuntu.bigbluebutton.org/lucid_dev_081/ bigbluebutton-{{ grains['lsb_distrib_codename'] }} main
    - file: /etc/apt/sources.list.d/bigbluebutton.list
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - env:
        LANG: {{ encoding }}
        LC_ALL: {{ encoding }}
    - require:
      - cmd: bigbluebutton
      - pkgrepo: bigbluebutton
      - pkg: bigbluebutton_ruby
      - pkg: libreoffice
      - pkg: openoffice
      - pkg: mscorefonts
      - archive: ffmpeg
      - module: redis_package
      - service: redis
      - service: tomcat
      - service: nginx
      - file: nginx_sysv_upstart
{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
      - file: /usr/bin/{{ i }}
{% endfor %}

bbb-conf-wrap:
  file:
    - managed
    - name: /usr/local/bin/bbb-conf-wrap.sh
    - source: salt://bbb/bbb-conf-wrap.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /usr/local

/usr/local/bin/bbb-conf-wrap.sh --setip {{ pillar['bbb']['hostname'] }}:
  cmd:
    - run
    - unless: grep -q {{ pillar['bbb']['hostname'] }} /var/www/bigbluebutton/client/conf/config.xml
    - require:
      - pkg: bigbluebutton
      - file: bbb-conf-wrap

nginx_sysv_upstart:
  file:
    - symlink
    - target: /lib/init/upstart-job
    - name: /etc/init.d/nginx
    - require:
      - pkg: nginx

/etc/nginx/conf.d/bigbluebutton.conf:
  file:
    - symlink
    - target: /etc/nginx/sites-available/bigbluebutton
    - require:
      - pkg: nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/bigbluebutton.conf
{%- endif -%}
