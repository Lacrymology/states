{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
