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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Install a Salt Management Master (server).

If you install a salt master from scratch, check and run bootstrap_archive.py
and use it to install the master.
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}

{%- set use_ext_pillar = salt['pillar.get']('salt_master:pillar:branch', False) and salt['pillar.get']('salt_master:pillar:remote', False) -%}

include:
  - local
  - git
{%- if use_ext_pillar %}
  - pip
{%- endif %}
  - python.dev
  - rsyslog
  - salt
  - ssh.client

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-master-requirements.txt:
  file:
    - absent

/srv/salt:
  file:
    - directory
    - user: root
    - group: root
    - mode: 551

/srv/pillars:
  file:
    - absent

{%- if use_ext_pillar %}
salt-master-requirements:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/salt.master
    - source: salt://salt/master/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/salt.master
    - watch:
      - file: salt-master-requirements
      - pkg: python-dev
    - watch_in:
      - service: salt-master
    - require_in:
      - pkg: salt-master
{%- else %}
/srv/pillars:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - pkg: salt-master
    - require_in:
      - service: salt-master
{%- endif %}

/srv/salt/top.sls:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/master/top.jinja2
    - require:
      - file: /srv/salt

salt-master-job_changes.py:
  file:
    - managed
    - name: /usr/local/bin/salt-master-job_changes.py
    - user: root
    - group: root
    - mode: 550
    - source: salt://salt/master/job_changes.py
    - require:
      - file: /usr/local

{%- from "macros.jinja2" import salt_version,salt_deb_version with context %}
{%- set version = salt_version() %}
{%- set pkg_version =  salt_deb_version() %}
{#- check deb filename carefully, number `1` after {1} is added only on 0.17.5-1
    pkg sub-version can be anything #}
{%- set master_path = '{0}/pool/main/s/salt/salt-master_{1}_all.deb'.format(version, pkg_version) %}
/etc/salt/master:
  file:
    - managed
    - source: salt://salt/master/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: salt-master
    - context:
      use_ext_pillar: {{ use_ext_pillar }}
salt-master:
  file:
    - managed
    - name: /etc/init/salt-master.conf
    - template: jinja
    - source: salt://salt/master/upstart.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: salt-master
  service:
    - running
    - enable: True
    - order: 90
    - require:
      - service: rsyslog
      - pkg: git
      - file: /var/cache/salt
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master
      - file: salt-master
      - cmd: salt
{#- PID file owned by root, no need to manage #}
  pkg:
    - installed
    - skip_verify: True
    - sources:
{%- if salt['pillar.get']('files_archive', False) %}
      - salt-master: {{ salt['pillar.get']('files_archive', False)|replace('file://', '')|replace('https://', 'http://') }}/mirror/salt/{{ master_path }}
{%- else %}
      - salt-master: http://archive.robotinfra.com/mirror/salt/{{ master_path }}
{%- endif %}
    - require:
      - cmd: salt
{%- if salt['pkg.version']('salt-master') not in ('', pkg_version) %}
      - pkg: salt_master_old_version

{{ manage_upstart_log('salt-master') }}

salt_master_old_version:
  pkg:
    - removed
    - name: salt-master
{%- endif %}
