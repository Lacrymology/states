{#
 Install a PostgreSQL database server.
 #}
{% set ssl = salt['pillar.get']('postgresql:ssl', False) %}
include:
  - postgresql
  - apt
{% if ssl %}
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
      - cmd: apt_sources
{% set encoding = pillar['encoding']|default("en_US.UTF-8") %}
    - env:
        LANG: {{ encoding }}
        LC_CTYPE: {{ encoding }}
        LC_COLLATE: {{ encoding }}
        LC_ALL: {{ encoding }}
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
{% if ssl %}
      - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
      - module: /etc/ssl/{{ ssl }}/server.pem
      - file: /etc/ssl/{{ ssl }}/ca.crt
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
