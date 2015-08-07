{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{%- set xmpp = salt["pillar.get"]("salt_master:xmpp", {}) %}

include:
  - apt.nrpe
  - bash.nrpe
  - cron
  - cron.nrpe
  - git.nrpe
  - pip.nrpe
  - nrpe
  - pysc.nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - ssh.client.nrpe
  - sudo
  - sudo.nrpe
{%- if xmpp %}
  - sleekxmpp.nrpe
{%- endif %}

/etc/sudoers.d/nrpe_salt_master:
  file:
    - managed
    - template: jinja
    - source: salt://salt/master/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/usr/lib/nagios/plugins/check_mine_minions.py:
  file:
    - managed
    - source: salt://salt/master/nrpe/check_mine.py
    - template: jinja
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server
      - module: nrpe-virtualenv
      - file: /etc/sudoers.d/nrpe_salt_master
      - file: nsca-salt.master
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

{{ passive_check('salt.master') }}

salt_mine_collect_minions_data:
  file:
    - name: /etc/cron.twice_daily/salt_mine_data
{%- if salt['pillar.get']('__test__', False) %}
    - absent
{%- else %}
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://salt/master/nrpe/cron.jinja2
    - require:
      - file: /etc/cron.twice_daily
      - file: /usr/lib/nagios/plugins/check_mine_minions.py
{%- endif %}

/usr/lib/nagios/plugins/check_git_branch.py:
  file:
    - managed
    - source: salt://salt/master/nrpe/check_git.py
    - template: jinja
    - user: root
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server
      - module: nrpe-virtualenv
      - file: /etc/sudoers.d/nrpe_salt_master
      - file: nsca-salt.master
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive
