{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

Nagios NRPE check for Salt Master.
-#}
{%- from 'nrpe/passive.sls' import passive_check with context %}
include:
  - apt.nrpe
  - git.nrpe
  - pip.nrpe
  - nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - ssh.client.nrpe
  - sudo
  - sudo.nrpe

/etc/sudoers.d/nrpe_salt_mine:
  file:
    - absent

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
    - user: nagios
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

salt_check_mine_nrpe_check:
  file:
    - absent
    - name: /usr/local/nagios/salt-check-mine-requirements.txt

salt_mine_collect_minions_data:
  file:
    - managed
    - name: /etc/cron.d/salt_mine_data
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://salt/master/nrpe/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/lib/nagios/plugins/check_mine_minions.py
    - watch_in:
      - service: cron

{{ passive_check('salt.master') }}
