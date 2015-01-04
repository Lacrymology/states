{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- set ssl = salt['pillar.get']('apt_cache:ssl', False) -%}
include:
  - apt
  - nginx
{%- if ssl %}
  - ssl
{%- endif %}

apt_cache:
  pkg:
    - installed
    - name: apt-cacher-ng
    - require:
      - cmd: apt_sources
  service:
    - running
    - name: apt-cacher-ng
    - require:
      - pkg: apt_cache

/etc/nginx/conf.d/apt_cache.conf:
  file:
    - managed
    - template: jinja
    - source: salt://apt_cache/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - service: apt_cache
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
