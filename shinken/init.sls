{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- macro shinken_install_module(module_name) %}
{#-
From version 2.0, :doc:`/shinken/doc/index` came with no modules, you need to
install them manually from `shinken.io <http://shinken.io/>`_ using shinken cli::

  /usr/local/shinken/bin/shinken install webui

What it actually does in this step are:

- download the file from ``shinken.io/grab/webui.tar``
- extract the module code into ``/var/lib/shinken/modules/webui/``
- and put the configuration file in ``/etc/shinken/modules/webui.cfg``

By default, the timeout value (300 seconds) is hard-coded in ``cli/shinkenio/cli.py``.
So, you may got an error when installing via a slow network::

  Sep 18 11:13:15 salt-minion[8893] salt.state: {'pid': 9780, 'retcode': 0,
  'stderr': '', 'stdout': "Grabbing : \nwebui\nThere was a critical error : (28,
  'Operation timed out after 300000 milliseconds with 3912 out of 3580384 bytes
  received')\nThe package webui cannot be found"}

It's the reason why we would like to mirror these modules to our archive
server, then install from that via ``--local`` option.

- Go to shinken.io
- Search for specific module
- Go to homepage ``https://github.com/shinken-monitoring/mod-webui``
- Download source ``https://github.com/shinken-monitoring/mod-webui/archive/master.zip``
- Extract, rename the folder to the same as the package name (``webui``)
- Re-pack, copy to the archive server
#}
shinken-module-{{ module_name }}:
    {%- if files_archive %}
  archive:
    - extracted
    - name: /usr/local/shinken/modules
    - source: {{ files_archive }}/mirror/shinken/{{ module_name }}.tar.xz
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
    - wait
    - user: shinken
    {%- if files_archive %}
    - name: /usr/local/shinken/bin/shinken install --local /usr/local/shinken/modules/{{ module_name }}
    {%- else %}
    - name: /usr/local/shinken/bin/shinken install {{ module_name }}
    {%- endif %}
    - onlyif: test $(/usr/local/shinken/bin/shinken inventory | grep -c {{ module_name }}) -eq 0
    - require:
      - file: shinken_python_path
    - watch:
      - file: /var/lib/shinken/.shinken.ini
      - cmd: shinken
    {%- if files_archive %}
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

/usr/local/shinken/salt-requirements.txt:
  file:
    - absent

shinken:
  pkg:
    - installed
    - pkgs:
      - libffi-dev
      - libcurl4-openssl-dev
    - require:
      - cmd: apt_sources
  virtualenv:
    - managed
    - name: /usr/local/shinken
    - system_site_packages: False
    - require:
      - module: virtualenv
      - file: /usr/local
  archive:
    - extracted
    - name: /usr/local/shinken/src
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/shinken/{{ version }}.tar.gz
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
    - name: {{ opts['cachedir'] }}/pip/shinken
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
    - requirements: {{ opts['cachedir'] }}/pip/shinken
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
    - require:
      - file: shinken_replace_etc_shinken
      - file: shinken_replace_etc
      - file: shinken_replace_init
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
    - backup: False
    - require:
      - archive: shinken

shinken_replace_etc:
  file:
    - replace
    - name: /usr/local/shinken/src/Shinken-{{ version }}/setup.py
    - pattern: "'/etc'"
    - repl: "'/usr/local/shinken/etc'"
    - backup: False
    - require:
      - archive: shinken

shinken_replace_init:
  file:
    - replace
    - name: /usr/local/shinken/src/Shinken-{{ version }}/setup.py
    - pattern: "'/etc/init.d/shinken"
    - repl: "'/usr/local/shinken/etc/init.d/shinken"
    - backup: False
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

{%- if files_archive %}
    {%- call shinken_install_module('pickle-retention-file-generic') %}
- source_hash: md5=a5f37f78caa61c92d8de75c20f4bf999
    {%- endcall %}
{%- else %}
    {{ shinken_install_module('pickle-retention-file-generic') }}
{%- endif %}
