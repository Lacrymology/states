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

Common stuff for all shinken components.
-#}
{% set version = "2.0.3" %}
include:
  - apt
  - bash
  - local
  - pip
  - python.dev
  - virtualenv
  - nrpe

{# common to all shinken daemons #}

/usr/local/bin/shinken-ctl.sh:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://shinken/shinken-ctl.jinja2
    - require:
      - file: /usr/local
      - file: bash

{% for dirname in ('log', 'lib') %}
/var/{{ dirname }}/shinken:
  file:
    - directory
    - user: shinken
    - group: shinken
    - mode: 770
    - require:
      - user: shinken
{% endfor %}

/etc/shinken:
  file:
    - directory
    - user: shinken
    - group: shinken
    - mode: 550
    - require:
      - user: shinken

/usr/local/shinken/src:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755
    - require:
      - virtualenv: shinken
      - file: /usr/local/bin/shinken-ctl.sh

shinken:
  virtualenv:
    - manage
    - name: /usr/local/shinken
    - system_site_packages: False
    - require:
      - module: virtualenv
      - file: /usr/local
{%- if 'files_archive' in pillar %}
  archive:
    - extracted
    - name: /usr/local/shinken/src
    - source: {{ pillar['files_archive'] }}/mirror/shinken-{{ version }}.tar.gz
    - source_hash: md5=2ea403179e257fb640b2b555598cacc4
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/shinken/src/shinken-{{ version }}
    - require:
      - file: /usr/local/shinken/src
{%- endif %}
  file:
    - managed
    - name: /usr/local/shinken/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/requirements.jinja2
    - context:
      version: {{ version }}
    - require:
      - virtualenv: shinken
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/shinken/bin/pip
    - requirements: /usr/local/shinken/salt-requirements.txt
    - require:
      - virtualenv: shinken
    - watch:
{%- if 'files_archive' in pillar %}
      - archive: shinken
{%- endif %}
      - file: shinken
      - pkg: python-dev
      - user: shinken
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/shinken
    - gid_from_name: True
    - groups:
      - nagios
    - require:
      - pkg: nagios-nrpe-server

/usr/local/shinken/src/shinken-1.4:
  file:
    - absent
    - require_in:
      - module: shinken
