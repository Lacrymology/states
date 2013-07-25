{#
 Install the Nginx web server
 #}
include:
  - apt
  - web
  - gsyslog

{% set bad_configs = ('default', 'example_ssl') %}

{% for filename in bad_configs %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file:
    - absent
    - require:
      - pkg: nginx
{% endfor %}

/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/config.jinja2
    - require:
      - pkg: nginx

nginx-old-init:
  file:
    - rename
    - name: /usr/share/nginx/init.d
    - source: /etc/init.d/nginx
    - require:
      - pkg: nginx
  cmd:
    - wait
    - name: dpkg-divert --divert /usr/share/nginx/init.d --add /etc/init.d/nginx
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init
  module:
    - wait
    - name: cmd.run
    - cmd: kill `cat /var/run/nginx.pid`
    - watch:
      - file: nginx-old-init

nginx-old-init-disable:
  cmd:
    - wait
    - name: update-rc.d -f nginx remove
    - require:
      - module: nginx-old-init
    - watch:
      - file: nginx-old-init

{% set logger_types = ('access', 'error') %}

{% for log_type in logger_types %}
/var/log/nginx/{{ log_type }}.log:
  file:
    - absent
    - require:
      - service: nginx

nginx-logger-{{ log_type }}:
  file:
    - managed
    - name: /etc/init/nginx-logger-{{ log_type }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/upstart_logger.jinja2
    - context:
      type: {{ log_type }}
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: gsyslog
      - file: nginx-logger-{{ log_type }}
      - pkg: nginx
{% endfor %}

/etc/logrotate.d/nginx:
  file:
    - absent
    - require:
      - pkg: nginx

nginx_dependencies:
  pkg:
    - installed
    - pkgs:
      - libpcre3-dev
      - libssl-dev
      - zlib1g-dev
      - lsb-base
      - adduser
    - require:
      - cmd: apt_sources 

{%- set version = '1.4.1' %}
{%- set filename = 'nginx_{0}-1~{1}_{2}.deb'.format(version, grains['lsb_codename'], grains['debian_arch']) %}

nginx:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - nginx: {{ pillar['files_archive']|replace('file://', '') }}/mirror/{{ filename }}
{%- else %}
      - nginx: http://nginx.org/packages/ubuntu/pool/nginx/n/nginx/{{ filename }}
{%- endif %}
    - require:
      - user: web
      - pkg: nginx_dependencies
  file:
    - managed
    - name: /etc/init/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/upstart.jinja2
    - require:
      - pkg: nginx
      - file: nginx-old-init
      - module: nginx-old-init
  service:
    - running
    - enable: True
    - watch:
      - file: nginx
      - file: /etc/nginx/nginx.conf
{% for filename in bad_configs %}
      - file: /etc/nginx/conf.d/{{ filename }}.conf
{% endfor %}
      - pkg: nginx
    - require:
{% for log_type in logger_types %}
      - service: nginx-logger-{{ log_type }}
{% endfor %}


/etc/apt/sources.list.d/nginx.org-packages_ubuntu-precise.list:
  file:
    - absent
