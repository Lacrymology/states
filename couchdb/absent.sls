{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('couchdb') }}

couchdb_pkgrepo_absent:
  file:
    - absent
    - name: /etc/apt/sources.list.d/couchdb-stable.list

couchdb_redirect_log_to_syslog:
  file:
    - absent
    - name: /etc/rsyslog.d/couchdb.conf

couchdb_logrotate_ensuring:
  file:
    - absent
    - name: /etc/logrotate.d/couchdb
    - require:
      - pkg: couchdb

extend:
  couchdb:
    pkg:
      - purged
      - require:
        - service: couchdb
    file:
      - absent
      - name: /etc/couchdb
      - require:
        - pkg: couchdb
    user:
      - absent
      - require:
        - pkg: couchdb
