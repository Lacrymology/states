{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


State for Shinken Arbiter.

A daemon reads the configuration, divides it into parts
(N schedulers = N parts), and distributes them to the appropriate Shinken
daemons. Additionally, it manages the high availability features: if a
particular daemon dies, it re-routes the configuration managed by this failed
daemon to the configured spare. Finally, it can receive input from users (such
as external commands from nagios.cmd) or passive check results and routes them
to the appropriate daemon. Passive check results are forwarded to the Scheduler
responsible for the check. There can only be one active arbiter with other
arbiters acting as hot standby spares in the architecture.
-#}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - hostname
  - rsyslog
  - shinken
{%- if ssl %}
  - ssl
{%- endif %}
  - ssmtp

{#{% if salt['pillar.get']('shinken:roles', False) %}#}
{#    {% if salt['pillar.get']('shinken:arbiter:use_mongodb', False) %}#}
{#  - mongodb#}
{#    {% endif %}#}
{#{% endif %}#}

{% set configs = ('architecture', 'infra') %}

shinken-arbiter:
  file:
    - managed
    - name: /etc/init/shinken-arbiter.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/arbiter/upstart.jinja2
    - require:
      - pkg: ssmtp
      - host: hostname
      - cmd: shinken
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - file: /var/run/shinken
      - file: /var/lib/shinken
      - file: /etc/shinken/objects
      - pkg: ssmtp
{#- does not use PID, no need to manage #}
    - watch:
      - user: shinken
      - cmd: shinken
      - cmd: shinken-module-pickle-retention-file-generic
      - file: shinken
      - file: shinken-arbiter
      - file: /etc/shinken/arbiter.conf
    {% for config in configs %}
      - file: /etc/shinken/{{ config }}.conf
    {% endfor %}
{%- if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}

/etc/shinken/arbiter.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/arbiter/config.jinja2
    - context:
        configs:
{% for config in configs %}
          - {{ config }}
{% endfor %}
    - require:
      - file: /etc/shinken
      - user: shinken

/etc/shinken/objects:
  file:
    - directory
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 550
    - require:
      - file: /etc/shinken
      - user: shinken

{% for config in configs %}
/etc/shinken/{{ config }}.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/{{ config }}.jinja2
    - require:
      - file: /etc/shinken
      - user: shinken
{% endfor %}

{% from 'upstart/rsyslog.jinja2' import manage_upstart_log with context %}
{{ manage_upstart_log('shinken-arbiter') }}
