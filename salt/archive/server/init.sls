{#-
Salt Archive Server HTTP/HTTPS
==============================

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.
salt_archive:
  web:
    hostnames:
      - archive.example.com
  keys:
    00daedbeef: ssh-dss

salt_archive:web:hostnames: list of hostname of the web archive
salt_archive:keys: dict of keys allowed to log in user

Optional Pillar
---------------

salt_archive:
  web:
    ssl: mykeyname
    ssl_redirect: True

salt_archive:web:ssl: SSL key to use to secure this server archive
salt_archive:web:ssl_redirect: if True, redirect all HTTP traffic to HTTPs
-#}

{%- set ssl = pillar['salt_archive']['web']['ssl']|default(False) -%}

include:
  - cron
  - nginx
  - salt.archive
{%- if ssl %}
  - ssl
{%- endif %}

/etc/cron.hourly/salt_archive:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://salt/archive/server/cron.jinja2
    - require:
      - pkg: cron
      - user: salt_archive

/etc/nginx/conf.d/salt_archive.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/archive/server/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - file: salt_archive
      - pkg: nginx

{% for key in salt['pillar.get']('salt_archive:keys', []) -%}
salt_archive_{{ key }}:
  ssh_auth:
    - present
    - name: {{ key }}
    - user: salt_archive
    - enc: {{ pillar['salt_archive']['keys'][key] }}
    - require:
      - user: salt_archive
{% endfor -%}

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/salt_archive.conf
{%- if ssl %}
        - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
        - module: /etc/ssl/{{ ssl }}/server.pem
        - file: /etc/ssl/{{ ssl }}/ca.crt
{%- endif -%}
