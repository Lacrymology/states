{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt
  - bash
  - cron
  - locale
  - mail
  - spamassassin

amavis:
  pkg:
    - latest
    - name: amavisd-new
    - require:
      - cmd: apt_sources
      - file: /etc/mailname
  user:
    - present
    - shell: /usr/sbin/nologin
    - require:
      - pkg: amavis
    - watch_in:
      - service: amavis
  service:
    - running
    - order: 50
    - watch:
      - pkg: amavis
    - require:
      - pkg: spamassassin

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

{%- call manage_pid('/var/run/amavis/amavisd.pid', 'amavis', 'amavis', 'amavis', 640) %}
- pkg: amavis
{%- endcall %}
