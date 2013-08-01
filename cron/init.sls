{#-
CRON Daemon
===========

Install daemon to execute scheduled commands (Vixie Cron).

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.

Optional Pillar
---------------

crontab_hour: 6
shinken_pollers:
  - 192.168.1.1

crontab_hour: Each days cron launch a daily group of tasks, they are located
    in /etc/cron.daily/. This is the time of the day when they're executed.
    Default: 6 hours in the morning, local time.
shinken_pollers: IP address of monitoring poller that check this server.
    Default: not used.
-#}

include:
  - apt
  - gsyslog

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
      - service: gsyslog
    - watch:
      - pkg: cron
      - file: /etc/crontab
