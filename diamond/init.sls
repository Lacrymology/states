{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
{% if salt['pillar.get']('shinken_pollers', []) %}
  - diamond.nrpe
{% endif %}
  - git
  - local
  - python.dev
  - rsyslog
  - rsyslog.diamond
  - virtualenv

/etc/diamond:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

/etc/diamond/collectors:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - file: /etc/diamond

diamond_requirements:
  file:
    - managed
    - name: /usr/local/diamond/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/requirements.jinja2
    - require:
      - virtualenv: diamond

diamond.conf:
  file:
    - managed
    - name: /etc/diamond/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/config.jinja2
    - require:
      - file: /etc/diamond

diamond:
  virtualenv:
    - manage
    - upgrade: True
    - name: /usr/local/diamond
    - require:
      - module: virtualenv
      - file: /usr/local
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-requirements.txt
    - require:
      - pkg: git
    - watch:
      - pkg: python-dev
      - file: diamond_requirements
  file:
    - managed
    - name: /etc/init/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/upstart.jinja2
    - require:
      - module: diamond
  service:
    {#- does not use PID, no need to manage #}
    - running
    - enable: True
    - order: 50
    - require:
      - service: rsyslog
    - watch:
      - virtualenv: diamond
      - file: diamond.conf
      - file: diamond
      - module: diamond
      - cmd: diamond
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
  cmd:
    - wait
    - name: find /usr/local/diamond -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: diamond

{{ manage_upstart_log('diamond') }}

/etc/diamond/collectors/ProcessResourcesCollector.conf:
  file:
    - managed
    - template: jinja
    - source: salt://diamond/ProcessResourcesCollector.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/diamond/collectors
