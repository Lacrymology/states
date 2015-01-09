{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}

include:
  - apt
  - bash
  - rsyslog

cron:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/crontab
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://cron/crontab.jinja2
    - require:
      - pkg: cron
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - service: rsyslog
    - watch:
      - pkg: cron
      - file: cron

{#-
 ``cron.twice_daily`` is script that need to run more than 1 a day, mostly
 monitoring checks.
 #}
/etc/cron.twice_daily:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - pkg: cron

{#- PID file owned by root, no need to manage #}
