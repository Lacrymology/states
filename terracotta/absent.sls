{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{%- set version = '3.7.0' %}

{{ upstart_absent('terracotta') }}

extend:
  terracotta:
    user:
      - absent
      - purge: True
      - require:
        - service: terracotta

/usr/local/terracotta-{{ version }}:
  file:
    - absent
    - name: /usr/local/terracotta-{{ version }}
    - require:
      - service: terracotta

/etc/terracotta.conf:
  file:
    - absent
    - require:
      - service: terracotta

/var/lib/terracotta:
  file:
    - absent
    - require:
      - service: terracotta

/var/log/terracotta:
  file:
    - absent
    - require:
      - service: terracotta
