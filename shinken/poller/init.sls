{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Shinken Poller state.

The poller daemon launches check plugins as requested by schedulers. When the
check is finished it returns the result to the schedulers. Pollers can be
tagged for specialized checks (ex. Windows versus Unix, customer A versus
customer B, DMZ) There can be many pollers for load-balancing or hot standby
spare roles.
-#}
{%- from 'shinken/init.sls' import shinken_install_module with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - apt
  - nrpe
  - shinken
  - rsyslog
  - ssl.dev
{% if ssl %}
  - ssl
{% endif %}

nagios-nrpe-plugin:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: nagios-plugins

{%- if salt['pillar.get']('files_archive', False) %}
    {%- call shinken_install_module('booster-nrpe') %}
- source_hash: md5=e8fa66f1360d2cc3cea10abf35e228d5
    {%- endcall %}
{%- else %}
    {{ shinken_install_module('booster-nrpe') }}
{%- endif %}

shinken-poller:
  file:
    - managed
    - name: /etc/init/shinken-poller.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
        shinken_component: poller
        max_filedescriptors: {{ salt['pillar.get']('shinken:poller_max_fd', 16384) }}
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - file: /var/lib/shinken
      - file: /var/run/shinken
      - pkg: nagios-nrpe-plugin
    - watch:
      - cmd: shinken
      - cmd: shinken-module-booster-nrpe
      - file: /etc/shinken/poller.conf
      - file: shinken-poller
      - user: shinken
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
{#- does not use PID, no need to manage #}
{% from 'upstart/rsyslog.jinja2' import manage_upstart_log with context %}
{{ manage_upstart_log('shinken-poller') }}

/etc/shinken/poller.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
        shinken_component: poller
    - require:
      - virtualenv: shinken
      - user: shinken
      - file: /etc/shinken

extend:
  shinken:
    module:
      - watch:
        - pkg: ssl-dev
