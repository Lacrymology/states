{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{% from 'upstart/rsyslog.jinja2' import manage_upstart_log with context %}
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- set mirror = files_archive|replace('https://', 'http://') ~ "/mirror/syncthing"
    if files_archive else "http://archive.robotinfra.com/mirror/syncthing" %}
{%- set version = "0.11.24" %}
{%- set repo = mirror ~ "/" ~ version %}
{%- set ssl = salt["pillar.get"]("syncthing:ssl", False) %}
{%- set ssl_redirect = salt["pillar.get"]("syncthing:ssl_redirect", False) %}
{%- set hostnames = salt["pillar.get"]("syncthing:hostnames", [])|default(False, boolean=True) %}

include:
  - apt
  - rsyslog
{%- if hostnames %}
  - nginx
{%- endif %}
{%- if ssl %}
  - ssl
{%- endif %}

syncthing:
  user:
    - present
    - home: /var/lib/syncthing
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

/var/lib/syncthing/cert.pem:
  file:
    - managed
    - mode: 444
    - user: syncthing
    - group: syncthing
    - contents_pillar: syncthing:cert
    - require:
      - user: syncthing
    - watch_in:
      - service: syncthing

/var/lib/syncthing/key.pem:
  file:
    - managed
    - mode: 400
    - user: syncthing
    - group: syncthing
    - contents_pillar: syncthing:key
    - require:
      - user: syncthing
    - watch_in:
      - service: syncthing

{%- set folders = salt["pillar.get"]("syncthing:folders", {}) %}
{%- for config in folders.itervalues() %}
  {%- do config["devices"].append(grains["id"]) %}
{%- endfor %}
{%- do folders.update({"default": {"path": "/var/lib/syncthing/Sync", "devices": [grains["id"]]}}) %}
{%- set devices = salt["pillar.get"]("syncthing:devices", {}) %}
{%- do devices.update({grains["id"]: {"id": salt["pillar.get"]("syncthing:device_id")}}) %}
/var/lib/syncthing/config.xml:
  file:
    - managed
    - template: jinja
    - source: salt://syncthing/config.jinja2
    - mode: 400
    - user: syncthing
    - group: syncthing
    - context:
        folders: {{ folders }}
        devices: {{ devices }}
    - require:
      - file: /var/lib/syncthing/cert.pem
      - file: /var/lib/syncthing/key.pem
    - watch_in:
      - service: syncthing

{{ manage_upstart_log('syncthing', severity="info") }}

/etc/nginx/conf.d/syncthing.conf:
  file:
{%- if hostnames %}
    - managed
    - source: salt://syncthing/nginx.jinja2
    - template: jinja
    - user: root
    - group: www-data
    - mode: 440
    - context:
        ssl: {{ ssl }}
        ssl_redirect: {{ ssl_redirect }}
        hostnames: {{ hostnames }}
    - require:
      - pkg: nginx
      - service: syncthing
  {%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
  {%- endif %}
    - watch_in:
      - service: nginx
{%- else %}
    - absent
{%- endif %}

{%- if hostnames %}
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
{%- endif %}
