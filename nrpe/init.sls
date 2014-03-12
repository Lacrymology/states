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

Install Nagios NRPE Agent.
-#}
#TODO: set nagios user shell to /bin/false

include:
  - apt
  - apt.nrpe
  - cron
  - cron.nrpe
  - local
{% if 'graphite_address' in pillar %}
  - nrpe.diamond
{% endif %}
  - nrpe.rsyslog
  - pip
  - pip.nrpe
  - rsyslog
  - rsyslog.nrpe
  - sudo
  - virtualenv
  - virtualenv.nrpe

{% from 'nrpe/passive.sls' import passive_check with context %}

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/nagiosplugin:
  file:
    - absent

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/nagiosplugin-requirements.txt:
  file:
    - absent

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/nagios/nagiosplugin-requirements.txt:
  file:
    - absent

{#- Change /usr/local/nagios owner #}
/usr/local/nagios:
  file:
    - directory
    - user: nagios
    - group: nagios
    - recurse:
      - user
      - group
    - require:
      - module: nrpe-virtualenv

nrpe-virtualenv:
  {# remove system-wide nagiosplugin, only use one in our nrpe-virtualenv #}
  pip:
    - removed
    - name: nagiosplugin
    - require:
      - module: pip
  virtualenv:
    - manage
    - upgrade: True
    {#- some check need import salt code #}
    - system_site_packages: True
    - name: /usr/local/nagios
    - require:
      - module: virtualenv
      - pip: nrpe-virtualenv
      - file: /usr/local
  file:
    - managed
    - name: /usr/local/nagios/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nrpe/requirements.jinja2
    - require:
      - virtualenv: nrpe-virtualenv
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/salt-requirements.txt
    - require:
      - virtualenv: nrpe-virtualenv
    - watch:
      - file: nrpe-virtualenv

{#- hack for making sure that above virtualenv is used system_site_packages
    this only neccessary for existing virtualenv because the `virtualenv`
    state module does not support that properly #}
/usr/local/nagios/local/lib/python2.7/no-global-site-packages.txt:
  file:
    - absent
    - require:
      - virtualenv: nrpe-virtualenv
    - watch_in:
      - module: nrpe-virtualenv

nagios-plugins:
  pkg:
    - installed
    - pkgs:
      - nagios-plugins-standard
      - nagios-plugins-basic

nagios-nrpe-server:
  pkg:
    - latest
    - require:
      - pkg: nagios-plugins
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/nagios/nrpe.d/000-nagios-servers.cfg
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
      - file: /usr/lib/nagios/plugins/check_memory.py
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - pkg: nagios-nrpe-server
      - file: nagios-nrpe-server

/usr/local/nagios/bin/passive_check.py:
  file:
    - managed
    - source: salt://nrpe/passive_check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv

/usr/lib/nagios/plugins/check_domain.sh:
  file:
    - managed
    - source: salt://nrpe/check_domain.sh
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/bin/check_memory.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_memory.py:
  file:
    - managed
    - source: salt://nrpe/check.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server

/usr/lib/nagios/plugins/check_oom.py:
  file:
    - managed
    - source: salt://nrpe/check_oom.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server

/etc/sudoers.d/nrpe_oom:
  file:
    - managed
    - template: jinja
    - source: salt://nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo

/etc/send_nsca.conf:
  file:
    - managed
    - template: jinja
    - source: salt://nrpe/send_nsca.jinja2
    - user: nagios
    - group: nagios
    - mode: 440
    - require:
      - module: nrpe-virtualenv

{{ passive_check('nrpe') }}
