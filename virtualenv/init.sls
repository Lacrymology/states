{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - git
  - mercurial
  - pip

python-virtualenv:
  pkg:
    - purged

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/salt-virtualenv-requirements.txt:
  file:
    - absent

virtualenv:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/virtualenv
    - source: salt://virtualenv/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - module: pip
  module:
{%- if not salt['file.file_exists']('/usr/local/bin/virtualenv') -%}
    {#- force module to run if virtualenv isn't installed yet #}
    - run
{%- else %}
    - wait
    - watch:
      - file: virtualenv
{%- endif %}
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/virtualenv
    - require:
      - pkg: git
      - module: mercurial
{%- if not salt['file.file_exists']('/usr/local/bin/virtualenv') %}
      - file: virtualenv
{%- endif -%}
