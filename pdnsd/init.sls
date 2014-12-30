{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>

-#}
{%- set sections = salt['pillar.get']('pdnsd:sections', {}) %}
include:
  - apt

pdnsd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - debconf: pdnsd
{%- if sections is not mapping -%}
    {#- if `pdnsd:sections` is not defined, use /etc/resolv.conf #}
    - pkgs:
      - pdnsd
      - resolvconf
{%- endif %}
  debconf:
    - set
    - data:
        'pdnsd/conf': {'type': 'select', 'value': 'Manual'}
    - require:
      - pkg: apt_sources
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: /etc/default/pdnsd
      - file: /etc/pdnsd.conf
      - pkg: pdnsd
{#- PID file owned by root, no need to manage #}

/etc/default/pdnsd:
  file:
    - managed
    - require:
      - pkg: pdnsd
    - template: jinja
    - source: salt://pdnsd/default.jinja2
    - user: root
    - group: root
    - mode: 440

/etc/pdnsd.conf:
  file:
    - managed
    - template: jinja
    - source: salt://pdnsd/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: pdnsd
    - context:
        sections: {{ sections }}
