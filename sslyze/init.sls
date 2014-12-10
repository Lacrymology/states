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

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{% set version = "0.9" %}
include:
  - cron
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
{%- if salt['pillar.get']('files_archive', False) %}
    - source: {{ salt['pillar.get']('files_archive', False) }}/mirror/sslyze-{{ version|replace(".", "_") }}-linux{{ bits }}.zip
{%- else %}
    - source: https://github.com/iSECPartners/sslyze/releases/download/release-{{ version }}/sslyze-{{ version|replace(".", "_") }}-linux{{ bits }}.zip
{%- endif %}
    - source_hash: md5={{ sum }}
    - if_missing: /usr/local/src/sslyze-{{ version|replace(".", "_") }}-linux{{ bits }}
    - archive_format: zip
    - require:
      - file: /usr/local/src
      - pkg: salt_minion_deps
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
      - virtualenv: nrpe-virtualenv

{%- for name in salt['pillar.get']('ssl', []) -%}
    {%- for trust_store in ('apple', 'java', 'microsoft', 'mozilla') %}
sslyze_{{ name }}_{{ trust_store }}:
  file:
    - append
    - name: /usr/local/src/sslyze-{{ version|replace(".", "_") }}-linux{{ bits }}/plugins/data/trust_stores/{{ trust_store }}.pem
    - text: |
        {{ salt['pillar.get']('ssl:' + name + ':server_crt')|indent(8) }}
    - require:
      - archive: sslyze
    - require_in:
      - cmd: sslyze
    {%- endfor -%}
{%- endfor %}

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
      - module: nrpe-virtualenv
      - cmd: sslyze
      - pkg: salt_minion_deps
{#- consumers of sslyze check use cron, make them only require sslyze check script #}
      - pkg: cron
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive

sslyze_requirements:
  file:
    - absent
    - name: /usr/local/nagios/salt-sslyze-requirements.txt
