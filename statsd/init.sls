{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- set version='0.1.10' %}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - hostname
  - local
  - python.dev
  - rsyslog
  - virtualenv

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
{%- if salt['pillar.get']('files_archive', False) %}
  archive:
    - extracted
    - name: /usr/local/statsd/src
    - source: {{ salt['pillar.get']('files_archive', False) }}/pip/py-statsd-{{ version }}.tar.bz2
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
