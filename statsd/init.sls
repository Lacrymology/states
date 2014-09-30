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

Install PyStatsD daemon, a statsd nodejs equivalent in python.
-#}
{%- set version='0.1.10' %}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - hostname
  - local
  - python.dev
  - rsyslog
  - virtualenv

/var/log/statsd.log:
  file:
    - absent

/usr/local/statsd/src:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - require:
      - virtualenv: statsd

statsd:
  file:
    - managed
    - name: /etc/init/statsd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://statsd/upstart.jinja2
    - require:
      - module: statsd
  virtualenv:
    - manage
    - name: /usr/local/statsd
    - require:
      - module: virtualenv
      - file: /usr/local
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - host: hostname
      - service: rsyslog
    - watch:
      - file: statsd
      - virtualenv: statsd
      - module: statsd
{%- if 'files_archive' in pillar %}
  archive:
    - extracted
    - name: /usr/local/statsd/src
    - source: {{ pillar['files_archive'] }}/pip/py-statsd-{{ version }}.tar.bz2
    - source_hash: md5=536f1f28f527c2e7848ef3ce0bb613af
    - archive_format: tar
    - tar_options: j
    - if_missing: /usr/local/statsd/src/py-statsd-{{ version }}
    - require:
      - file: /usr/local/statsd/src
    - watch_in:
      - module: statsd
{%- endif %}
  module:
    - wait
    - name: pip.install
    - requirements: /usr/local/statsd/salt-requirements.txt
    - bin_env: /usr/local/statsd
    - require:
      - virtualenv: statsd
    - watch:
      - pkg: python-dev
      - file: statsd_requirements

{{ manage_upstart_log('statsd') }}

statsd_requirements:
  file:
    - managed
    - name: /usr/local/statsd/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://statsd/requirements.jinja2
    - context:
      version: {{ version }}
    - require:
      - virtualenv: statsd
