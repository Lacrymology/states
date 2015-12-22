{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set ssl = salt['pillar.get']('apt_cache:ssl', False) -%}
{%- set admin_username = salt["pillar.get"]("apt_cache:admin_username", False) %}
{%- set admin_password = salt["pillar.get"]("apt_cache:admin_password", False) %}
include:
  - apt
  - hostname
  - nginx
{%- if ssl %}
  - ssl
{%- endif %}

/etc/apt-cacher-ng/security.conf:
  file:
{%- if admin_username and admin_password %}
    - managed
    - source: salt://apt_cache/security.jinja2
    - template: jinja
    - user: root
    - group: apt-cacher-ng
    - mode: 440
    - show_diff: False
    - context:
        admin_username: {{ admin_username }}
        admin_password: {{ admin_password }}
    - require:
      - pkg: apt_cache
    - require_in:
      - service: apt_cache
{%- else %}
    - absent
{%- endif %}

/etc/rsyslog.d/apt-cacher-ng.conf:
  file:
    - managed
    - mode: 440
    - source: salt://rsyslog/template.jinja2
    - template: jinja
    - require:
      - pkg: rsyslog
      - file: /etc/apt-cacher-ng/acng.conf
    - watch_in:
      - service: rsyslog
    - context:
        file_path: /var/log/apt-cacher-ng/apt-cacher.err
        tag_name: apt-cacher-ng
        severity: error
        facility: daemon

/etc/apt-cacher-ng/acng.conf:
  file:
    - managed
    - source: salt://apt_cache/config.jinja2
    - template: jinja
    - user: root
    - group: apt-cacher-ng
    - mode: 440
    - require:
      - pkg: apt_cache
    - require_in:
      - service: apt_cache

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
    - context:
        appname: apt_cache
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
