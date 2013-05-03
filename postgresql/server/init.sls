{#
 Install a PostgreSQL database server.
 #}
include:
  - postgresql
{% if pillar['postgresql']['ssl']|default(False) %}
  - ssl
{% endif %}

{% set version="9.2" %}

postgresql:
  pkg:
    - latest
    - names:
      - postgresql-{{ version }}
      - postgresql-client-{{ version }}
    - require:
      - apt_repository: postgresql-dev
  file:
    - managed
    - name: /etc/postgresql/{{ version }}/main/postgresql.conf
    - source: salt://postgresql/server/config.jinja2
    - user: postgres
    - group: postgres
    - mode: 440
    - template: jinja
    - require:
      - pkg: postgresql
    - context:
      version: {{ version }}
  service:
    - running
    - enable: True
    - name: postgresql
    - watch:
      - pkg: postgresql
      - file: postgresql
{% if pillar['postgresql']['ssl']|default(False) %}
      - cmd: /etc/ssl/{{ pillar['postgresql']['ssl'] }}/chained_ca.crt
      - module: /etc/ssl/{{ pillar['postgresql']['ssl'] }}/server.pem
      - file: /etc/ssl/{{ pillar['postgresql']['ssl'] }}/ca.crt
{% endif %}

/etc/logrotate.d/postgresql-common:
  file:
    - absent
    - require:
      - pkg: postgresql

/var/log/postgresql/postgresql-{{ version }}-main.log:
  file:
    - absent
    - require:
      - service: postgresql
