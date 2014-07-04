{#-
Copyright (c) 2013, Quan Tong Anh
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

Author: Quan Tong Anh <tonganhquan.net@gmail.com>
Maintainer: Quan Tong Anh <tonganhquan.net@gmail.com>

A Python tool that can analyze the SSL configuration of a server
-#}
{% set version = "0.9" %}
include:
  - local
  - nrpe
  - salt.minion.deps
  - virtualenv

{%- if grains['osarch'] == 'amd64' -%}
    {%- set bits = "64" -%}
    {%- set sum = "1b5a235f97db11cc2f72ccb499d861f0" -%}
{%- else -%}
    {%- set bits = "32" -%}
    {%- set sum = "4471cfc348b4d1777fc39dc9200f6cc5" -%}
{%- endif %}

sslyze:
  archive:
    - extracted
    - name: /usr/local/src
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/mirror/sslyze-{{ version|replace(".", "_") }}-linux{{ bits }}.zip
{%- else %}
    - source: https://github.com/iSECPartners/sslyze/releases/download/release-{{ version }}/sslyze-{{ version|replace(".", "_") }}-linux{{ bits }}.zip
{%- endif %}
    - source_hash: md5={{ sum }}
    - if_missing: /usr/local/src/sslyze-{{ version|replace(".", "_") }}-linux{{ bits }}
    - archive_format: zip
    - require:
      - file: /usr/local/src
      - pkg: unzip
  cmd:
    - wait
{%- if grains['osarch'] == 'amd64' %}
    - cwd: /usr/local/src/sslyze-{{ version|replace(".", "_") }}-linux64
{%- else %}
    - cwd: /usr/local/src/sslyze-{{ version|replace(".", "_") }}-linux32
{%- endif %}
    - name: /usr/local/nagios/bin/python setup.py install
    - watch:
      - archive: sslyze
    - require:
      - virtualenv: nrpe-virtualenv

check_ssl_configuration.py:
  file:
    - managed
    - name: /usr/lib/nagios/plugins/check_ssl_configuration.py
    - source: salt://sslyze/check_ssl_configuration.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - pkg: nagios-nrpe-server
      - cmd: sslyze
      - pkg: dnsutils

sslyze_requirements:
  file:
    - managed
    - name: /usr/local/nagios/salt-sslyze-requirements.txt
    - source: salt://sslyze/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - virtualenv: nrpe-virtualenv
      - pkg: nagios-nrpe-server
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/nagios
    - requirements: /usr/local/nagios/salt-sslyze-requirements.txt
    - watch:
      - file: sslyze_requirements
