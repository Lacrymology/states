{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('xl2tpd') }}

extend:
  xl2tpd:
    pkg:
      - purged
      - require:
        - service: xl2tpd
