{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - diamond
  - openvpn.static
  - rsyslog.diamond

openvpn_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/OpenVPNCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/diamond/config.jinja2
    - context:
        instances:
{%- set openvpn = salt['pillar.get']('openvpn', {}) %}
{%- for tunnel in openvpn %}
          {{ tunnel }}: file:///var/lib/openvpn/{{ tunnel }}.log
{%- endfor %}
    - require:
      - file: /etc/diamond/collectors
{%- for tunnel in openvpn %}
      - service: openvpn-{{ tunnel }}
{%- endfor %}
    - watch_in:
      - service: diamond

openvpn_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require:
{%- for tunnel in openvpn %}
      - service: openvpn-{{ tunnel }}
{%- endfor %}
    - text:
      - |
        [[openvpn]]
        exe = ^\/usr\/sbin\/openvpn$
