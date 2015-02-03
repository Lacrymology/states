{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('squid3') }}

squid:
  pkg:
    - purged
    - name: squid3-common
    - require:
      - service: squid3
  file:
    - absent
    - name: /etc/squid3/
    - require:
      - pkg: squid

squid_pid:
  file:
    - absent
    - name: /var/run/squid3.pid
    - require:
      - pkg: squid

squid_data:
  file:
    - absent
    - name: /var/spool/squid3
    - require:
      - pkg: squid

squid_usr_share:
  file:
    - absent
    - name: /usr/share/squid3
    - require:
      - pkg: squid
