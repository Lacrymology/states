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

openoffice:
  pkg:
    - installed
    - sources:
  {%- if 'files_archive' in pillar %}
      - openoffice.org: {{ pillar['files_archive']|replace('file://', '') }}/mirror/openoffice.org_1.0.4_all.deb
  {%- else %}
      - openoffice.org: http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb
  {%- endif %}

ruby_dependencies:
  pkg:
    - installed
    - pkgs:
      - libffi5
      - libreadline5
    - require:
      - cmd: apt_sources

bigbluebutton_ruby:
  pkg:
    - installed
    - sources:
  {%- if 'files_archive' in pillar %}
      - ruby1.9.2: {{ pillar['files_archive']|replace('file://', '') }}/mirror/ruby1.9.2_1.9.2-p290-1_amd64.deb
  {%- else %}
      - ruby1.9.2: https://bigbluebutton.googlecode.com/files/ruby1.9.2_1.9.2-p290-1_amd64.deb
  {%- endif %}
    - require:
      - pkg: ruby_dependencies

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

{% set encoding = pillar['encoding']|default("en_US.UTF-8") %}
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
      - pkg: python-apt
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

/usr/local/bin/bbb-conf-wrap.sh --setip {{ salt['pillar.get']('bbb:hostname') }}:
  cmd:
    - run
    - unless: grep -q {{ salt['pillar.get']('bbb:hostname') }} /var/www/bigbluebutton/client/conf/config.xml
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
