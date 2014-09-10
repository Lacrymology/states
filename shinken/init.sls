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
{% if salt['pillar.get']('shinken:ssl', False) %}
  - ssl
{% endif %}

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

shinken_dependencies:
  pkg:
    - installed
    - pkgs:
      - libffi-dev
      - libcurl4-openssl-dev
    - require:
      - cmd: apt_sources

shinken:
  virtualenv:
    - manage
    - name: /usr/local/shinken
    - system_site_packages: False
    - require:
      - module: virtualenv
      - file: /usr/local
  archive:
    - extracted
    - name: /usr/local/shinken/src
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/pip/Shinken-{{ version }}.tar.gz
{%- else %}
    - source: https://pypi.python.org/packages/source/S/Shinken/Shinken-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=0350cc0fbeba6405d88e5fbce3580a91
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/shinken/src/Shinken-{{ version }}
    - require:
      - file: /usr/local/shinken/src
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
      - file: shinken
      - pkg: python-dev
      - user: shinken
{%- if salt['pillar.get']('shinken:ssl', False) %}
      - pkg: shinken_dependencies
{%- endif %}
  cmd:
    - wait
    - cwd: /usr/local/shinken/src/Shinken-{{ version }}
    - name: /usr/local/shinken/bin/python setup.py install --install-scripts=/usr/local/shinken/bin
    - watch:
      - virtualenv: shinken
      - archive: shinken
    - require:
      - module: shinken
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/shinken
    - gid_from_name: True
    - groups:
      - nagios
{%- if salt['pillar.get']('shinken:ssl', False) %}
      - ssl-cert
{%- endif %}
    - require:
      - pkg: nagios-nrpe-server
      - pkg: ssl-cert

/usr/local/shinken/src/shinken-1.4:
  file:
    - absent
    - require_in:
      - cmd: shinken
