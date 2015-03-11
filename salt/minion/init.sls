{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
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

salt_minion_cron_highstate:
  file:
    - absent
    - name: /etc/cron.daily/salt_highstate
