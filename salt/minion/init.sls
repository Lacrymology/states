{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Install Salt Minion (client).
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
{%- set highstate = salt['pillar.get']('salt:highstate', True) %}
{%- if highstate %}
  - bash
  - cron
{%- endif %}
  - pysc
  - raven
  - requests
  - rsyslog
  - salt.minion.upgrade
  - sudo

{# it's mandatory to remove this file if the master is changed #}
salt_minion_master_key:
  module:
    - wait
    - name: file.remove
    - path: /etc/salt/pki/minion/minion_master.pub
    - watch:
      - file: /etc/salt/minion
    - watch_in:
      - service: salt-minion

{{ opts['cachedir'] }}/pkg_installed.pickle:
  file:
    - absent

{{ manage_upstart_log('salt-minion') }}

extend:
  salt-minion:
    service:
      - require:
        - service: rsyslog
    pkg:
      - installed
      - require:
        - pkgrepo: salt
        - cmd: apt_sources
        - pkg: apt_sources

salt-fire-event:
  group:
    - present

/etc/sudoers.d/salt_fire_event:
  file:
    - managed
    - template: jinja
    - source: salt://salt/minion/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo
      - group: salt-fire-event

/usr/local/bin/salt_fire_event.py:
  file:
    - managed
    - template: jinja
    - source: salt://salt/minion/salt_fire_event.py
    - mode: 551
    - user: root
    - group: root
    - require:
      - pkg: salt-minion
      - module: pysc

/etc/cron.daily/salt_highstate:
  file:
{%- if highstate %}
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://salt/minion/cron.jinja2
    - require:
      - pkg: cron
      - file: bash
{%- else %}
    - absent
{%- endif %}
