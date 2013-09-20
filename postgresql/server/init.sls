{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
