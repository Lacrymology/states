{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "os.jinja2" import os with context %}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - amavis.common
  - apt
  - bash
  - cron
  - locale
  - mail
  - spamassassin

extend:
  amavis:
    service:
      - running
      - order: 50
      - watch:
        - pkg: amavis
        - user: amavis
      - require:
        - cmd: pyzor_test

/etc/amavis/conf.d/50-user:
  file:
    - managed
    - source: salt://amavis/config.jinja2
    - template: jinja
    - mode: 440
    - watch_in:
      - service: amavis

/etc/cron.daily/amavisd-new:
  file:
{%- if os.is_precise %}
    - managed
    - source: salt://amavis/cron_daily.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 500
    - require:
      - pkg: cron
      - file: bash
      - cmd: system_locale
      - pkg: amavis
{%- else %}
    {#-
    On trusty, this cron job was moved to /etc/cron.d/
    Moreover, `/usr/sbin/amavisd-new-cronjob` must be run as `amavis` user
    #}
    - absent

/var/lib/amavis/.spamassassin:
  file:
    - directory
    - user: amavis
    - group: amavis
    - mode: 700
    - require:
      - user: amavis

/var/lib/amavis/.spamassassin/user_prefs:
  file:
    - managed
    - user: amavis
    - group: amavis
    - mode: 640
    - require:
      - file: /var/lib/amavis/.spamassassin
{%- endif %}

{%- call manage_pid('/var/run/amavis/amavisd.pid', 'amavis', 'amavis', 'amavis', 640) %}
- pkg: amavis
{%- endcall %}
