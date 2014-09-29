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
{%- macro shinken_install_module(module_name) %}
shinken-module-{{ module_name }}:
    {%- if 'files_archive' in pillar %}
  archive:
    - extracted
    - name: /usr/local/shinken/modules
    - source: {{ pillar['files_archive'] }}/mirror/shinken/{{ module_name }}.tar.xz
    {%- if caller is defined -%}
        {%- for line in caller().split("\n") %}
{{ line|trim|indent(4, indentfirst=True) }}
        {%- endfor -%}
    {%- endif %}
    - archive_format: tar
    - tar_options: J
    - if_missing: /usr/local/shinken/modules/{{ module_name }}
    - require:
      - file: /usr/local/shinken/modules
    {%- endif %}
  cmd:
    - run
    - user: shinken
    {%- if 'files_archive' in pillar %}
    - name: /usr/local/shinken/bin/shinken install --local /usr/local/shinken/modules/{{ module_name }}
    {%- else %}
    - name: /usr/local/shinken/bin/shinken install {{ module_name }}
    {%- endif %}
    - onlyif: test $(/usr/local/shinken/bin/shinken inventory | grep -c {{ module_name }}) -eq 0
    - watch:
      - file: /var/lib/shinken/.shinken.ini
      - cmd: shinken
    {%- if 'files_archive' in pillar %}
      - archive: shinken-module-{{ module_name }}
    {%- endif %}
{%- endmacro %}

{% set version = "2.0.3" %}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - apt
  - bash
  - local
  - pip
  - python.dev
  - virtualenv
  - nrpe
{% if ssl %}
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

/var/log/shinken:
  file:
    - absent

{% for dirname in ('lib', 'run') %}
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

/usr/local/shinken/modules:
  file:
    - directory
    - user: shinken
    - group: shinken
    - mode: 755
    - require:
      - virtualenv: shinken

shinken:
  pkg:
    - installed
    - pkgs:
      - libffi-dev
      - libcurl4-openssl-dev
    - require:
      - cmd: apt_sources
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
    - source: {{ pillar['files_archive'] }}/mirror/shinken/{{ version }}.tar.gz
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
      - pkg: shinken
  cmd:
    - wait
    - cwd: /usr/local/shinken/src/Shinken-{{ version }}
    - name: /usr/local/shinken/bin/python setup.py install --install-scripts=/usr/local/shinken/bin --record=/usr/local/shinken/install.log
    - watch:
      - archive: shinken
      - file: shinken_replace_etc_shinken
      - file: shinken_replace_etc
      - file: shinken_replace_init
    - require:
      - module: shinken
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/shinken
    - gid_from_name: True
    - groups:
      - nagios
{%- if ssl %}
      - ssl-cert
{%- endif %}
    - require:
      - pkg: nagios-nrpe-server
{%- if ssl %}
      - pkg: ssl-cert
{%- endif %}

shinken_replace_etc_shinken:
  file:
    - replace
    - name: /usr/local/shinken/src/Shinken-{{ version }}/setup.py
    - pattern: '"/etc/shinken"'
    - repl: '"/usr/local/shinken/etc/shinken"'
    - require:
      - archive: shinken

shinken_replace_etc:
  file:
    - replace
    - name: /usr/local/shinken/src/Shinken-{{ version }}/setup.py
    - pattern: "'/etc'"
    - repl: "'/usr/local/shinken/etc'"
    - require:
      - archive: shinken

shinken_replace_init:
  file:
    - replace
    - name: /usr/local/shinken/src/Shinken-{{ version }}/setup.py
    - pattern: "'/etc/init.d/shinken"
    - repl: "'/usr/local/shinken/etc/init.d/shinken"
    - require:
      - archive: shinken

{%- for suffix in ('', '-arbiter', '-broker', '-discovery', '-poller', '-reactionner', '-receiver', '-scheduler') %}
shinken{{ suffix }}_python_path:
  file:
    - replace
    - name: /usr/local/shinken/src/Shinken-{{ version }}/bin/shinken{{ suffix }}
    - pattern: "#!/usr/bin/env python"
    - repl: "#!/usr/local/shinken/bin/python"
    - backup: False
    - require:
      - archive: shinken
    - watch_in:
      - cmd: shinken
{%- endfor %}

/var/lib/shinken/.shinken.ini:
  file:
    - managed
    - source: salt://shinken/shinken.ini
    - user: shinken
    - group: shinken
    - mode: 750
    - require:
      - user: shinken

{%- if 'files_archive' in pillar %}
    {%- call shinken_install_module('pickle-retention-file-generic') %}
- source_hash: md5=a5f37f78caa61c92d8de75c20f4bf999
    {%- endcall %}
{%- else %}
    {{ shinken_install_module('pickle-retention-file-generic') }}
{%- endif %}

{%- if salt['cmd.retcode']("/usr/local/shinken/bin/pip show shinken | grep 'Version: 1.4'") == 0 -%}
    {%- if salt['file.directory_exists']('/usr/local/shinken/src/shinken-1.4') %}
shinken_stop_old_daemons:
  cmd:
    - run
    - name: /usr/local/bin/shinken-ctl.sh stop

shinken_remove_old_scripts:
  cmd:
    - run
    - name: rm -f /usr/local/shinken/bin/shinken*
    - onlyif: ls /usr/local/shinken/bin/shinken*

/usr/local/shinken/src/shinken-1.4:
  file:
    - absent
    - require:
      - cmd: shinken_stop_old_daemons
      - cmd: shinken_remove_old_scripts
    - require_in:
      - cmd: shinken
    {%- endif -%}
{%- endif %}
