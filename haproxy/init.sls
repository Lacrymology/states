{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- set mirror = files_archive|replace('https://', 'http://') ~ "/mirror/haproxy"
    if files_archive else "http://archive.robotinfra.com/mirror/haproxy" %}
{%- set version = "1.5.14" %}
{%- set repo = mirror ~ "/" ~ version %}

{%- from 'haproxy/check_ssl.jinja2' import ssl_certs with context %}

include:
  - apt
{%- if ssl_certs %}
  - ssl
{%- endif %}

haproxy:
  pkgrepo:
    - managed
    - name: deb {{ repo }} {{ grains['oscodename'] }} main
    - key_url: salt://haproxy/key.gpg
    - file: /etc/apt/sources.list.d/haproxy.list
    - clean_file: True
    - require:
      - pkg: apt_sources
  pkg:
    - installed
    - require:
      - pkgrepo: haproxy
  file:
    - managed
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/config.jinja2
    - template: jinja
    - user: root
    - group: haproxy
    - mode: 440
    - context:
        ssl_certs: {{ ssl_certs }}
    - require:
      - pkg: haproxy
  service:
    - running
    - watch:
      - pkg: haproxy
      - file: haproxy
      - file: /etc/default/haproxy
{%- if ssl_certs -%}
  {%- for cert in ssl_certs %}
      - cmd: ssl_cert_and_key_for_{{ cert }}
  {%- endfor -%}
{%- endif %}

/etc/default/haproxy:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}
        ENABLED=1
    - require:
      - pkg: haproxy
