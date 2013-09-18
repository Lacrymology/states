{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Install a PostgreSQL database server.

Sample config:
postgresql:
  listen_addresses: '*'
  replication:
    password: mypass
    hot_standby: True
    master: 10.0.0.5
    standby:
      - 10.0.0.7
  password: pass
  diamond: pass

Mandatory Pillar
----------------

None

Optional Pillar
---------------

postgresql:
  listen_addresses: '*' # Default: localhost
  diamond: password for diamond # Default: auto-generate by salt
  replication: # only used for cluster setup
    username: usr name used for replication # Default replication_agent
    hot_standby: True # Default: True
    # bellow is manadatory if you are setup a cluster
    master: 10.0.0.5 # address of master server
    standby:
      - 10.0.0.7
      - other_standby_address


-#}
{% set ssl = salt['pillar.get']('postgresql:ssl', False) %}
include:
  - hostname
  - postgresql
  - apt
  - rsyslog
  - locale
{% if ssl %}
  - ssl
{% endif %}

{% set version="9.2" %}

postgresql:
  pkg:
    - latest
    - pkgs:
      - postgresql-{{ version }}
      - postgresql-client-{{ version }}
    - require:
      - cmd: system_locale
      - pkgrepo: postgresql-dev
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
    - order: 50
    - name: postgresql
    - require:
      - service: rsyslog
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
