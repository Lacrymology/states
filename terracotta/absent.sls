{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{%- set version = '3.7.0' %}

{{ upstart_absent('terracotta') }}

extend:
  terracotta:
    user:
      - absent
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
