{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - apt
  - rsyslog

openvpn:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

/etc/default/openvpn:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/default.jinja2
    - require:
      - pkg: openvpn

{%- for type in ('lib', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770
{%- endfor %}

{%- macro service_openvpn(tunnels) %}
    {%- for tunnel in tunnels %}
openvpn-{{ tunnel }}:
  file:
    - managed
    - name: /etc/init/openvpn-{{ tunnel }}.conf
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/upstart.jinja2
    - template: jinja
    - require:
      - file: /etc/openvpn/{{ tunnel }}/config
      - file: /var/lib/openvpn
      - file: /var/log/openvpn
    - context:
        identifier: {{ tunnel }}
  service:
    - running
    - order: 50
    - watch:
      - file: openvpn-{{ tunnel }}

{{ manage_upstart_log('openvpn-' + tunnel) }}

    {%- endfor -%}
{%- endmacro -%}
{#- does not use PID, no need to manage #}
