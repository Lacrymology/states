{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('cron') }}

extend:
  cron:
    pkg:
      - purged
      - require:
        - service: cron

cron_absent_crond:
  file:
    - absent
    - name: /etc/cron.d
    - require:
      - pkg: cron

/etc/cron.twice_daily:
  file:
    - absent
    - require:
      - pkg: cron

cron_absent_crontab:
  file:
    - absent
    - name: /etc/crontab
    - require:
      - pkg: cron
