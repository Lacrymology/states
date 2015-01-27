{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- set tunnels = salt['pillar.get']('openvpn:servers', {}) %}

include:
  - diamond
  - openvpn.static
  - openvpn.tls
  - rsyslog.diamond

{%- if tunnels %}
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
    {%- for tunnel in tunnels %}
          {{ tunnel }}: file:///var/lib/openvpn/{{ tunnel }}.log
    {%- endfor %}
    - require:
      - file: /etc/diamond/collectors
    {%- for tunnel in tunnels %}
        {%- if tunnels[tunnel]['mode'] == 'static' %}
      - service: openvpn-{{ tunnel }}
        {%- else %}
      - cmd: restart_openvpn_{{ tunnel }}
        {%- endif %}
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
    {%- for tunnel in tunnels %}
        {%- if tunnels[tunnel]['mode'] == 'static' %}
      - service: openvpn-{{ tunnel }}
        {%- else %}
      - cmd: restart_openvpn_{{ tunnel }}
        {%- endif %}
    {%- endfor %}
    - text:
      - |
        [[openvpn]]
        exe = ^\/usr\/sbin\/openvpn$
{%- endif %}
