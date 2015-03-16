{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - pysc
  - raven
  - requests
  - rsyslog
  - salt.event
  - salt.minion.upgrade

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


salt_minion_cron_highstate:
  file:
    - absent
    - name: /etc/cron.daily/salt_highstate
