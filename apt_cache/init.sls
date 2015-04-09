{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set ssl = salt['pillar.get']('apt_cache:ssl', False) -%}
include:
  - apt
  - hostname
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
      - host: hostname
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
    - user: root
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
