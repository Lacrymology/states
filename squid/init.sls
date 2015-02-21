{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'macros.jinja2' import manage_pid with context %}

include:
  - apt
  - debian.users

squid:
  pkg:
    - installed
    - name: squid3
    - require:
      - cmd: apt_sources
  service:
    - running
    - name: squid3
    - enable: True
    - require:
      - pkg: squid
  file:
    - managed
    - name: /etc/squid3/squid.conf
    - template: jinja
    - source: salt://squid/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: squid
{#- for predefined user ``proxy`` #}
      - cmd: base-passwd
    - watch_in:
      - service: squid

{%- call manage_pid('/var/run/squid3.pid', 'root', 'proxy', 'squid') %}
- cmd: base-passwd
{%- endcall %}
