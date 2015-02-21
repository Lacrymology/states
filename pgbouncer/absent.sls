{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

pgbouncer:
  service:
    - dead
    - enable: False
  pkg:
    - purged
    - require:
      - service: pgbouncer
  file:
    - absent
    - name: /etc/pgbouncer
    - require:
      - pkg: pgbouncer

{%- for file in ('/etc/default/pgbouncer', '/etc/init.d/pgbouncer') %}
{{ file }}:
  file:
    - absent
    - require:
      - pkg: pgbouncer
{%- endfor %}
