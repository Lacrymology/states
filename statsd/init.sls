{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
  archive:
    - extracted
    - name: /usr/local/statsd/src
    - source: {{ files_archive }}/pip/py-statsd-{{ version }}.tar.bz2
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
    - requirements: {{ opts['cachedir'] }}/pip/statsd
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
    - name: {{ opts['cachedir'] }}/pip/statsd
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://statsd/requirements.jinja2
    - context:
        version: {{ version }}
    - require:
      - virtualenv: statsd
