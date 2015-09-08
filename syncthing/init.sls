{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- set mirror = files_archive|replace('https://', 'http://') ~ "/mirror/syncthing"
    if files_archive else "http://archive.robotinfra.com/mirror/syncthing" %}
{%- set version = "0.11.24" %}
{%- set repo = mirror ~ "/" ~ version %}
{%- set ssl = salt["pillar.get"]("syncthing:ssl", False) %}

include:
  - apt
  - nginx
  - rsyslog
{%- if ssl %}
  - ssl
{%- endif %}

syncthing:
  user:
    - present
    - shell: /bin/false
  pkgrepo:
    - managed
    - name: deb {{ repo }} syncthing release
    - key_url: salt://syncthing/key.gpg
    - file: /etc/apt/sources.list.d/syncthing.list
    - clean_file: True
    - require:
      - pkg: apt_sources
  pkg:
    - latest
    - name: syncthing
    - require:
      - pkgrepo: syncthing
  file:
    - managed
    - name: /etc/init/syncthing.conf
    - template: jinja
    - source: salt://syncthing/upstart.jinja2
    - mode: 440
    - user: root
    - group: root
    - context:
        username: "admin"
        password: {{ salt["pillar.get"]("syncthing:password") }}
    - require:
      - pkg: syncthing
      - user: syncthing
  service:
    - running
    - enable: True
    - require:
      - service: rsyslog
    - watch:
      - pkg: syncthing
      - file: syncthing

{% from 'upstart/rsyslog.jinja2' import manage_upstart_log with context %}
{{ manage_upstart_log('syncthing', severity="info") }}

/etc/nginx/conf.d/syncthing.conf:
  file:
    - managed
    - source: salt://syncthing/nginx.jinja2
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - context:
        ssl: {{ salt["pillar.get"]("syncthing:ssl", False) }}
        ssl_redirect: {{ salt["pillar.get"]("syncthing:ssl_redirect", False) }}
        hostnames: {{ salt["pillar.get"]("syncthing:hostnames") }}
    - require:
      - pkg: nginx
      - service: syncthing
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
    - watch_in:
      - service: nginx

{%- if ssl %}
extend:
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
{%- endif %}
