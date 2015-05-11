{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- set instances = salt['pillar.get']('pppd:instances', {}) -%}

include:
  - apt

ppp:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

{%- for server_name in instances %}
ppp-options-{{ server_name }}:
  file:
    - managed
    - name: /etc/ppp/{{ server_name }}-options
    - source: salt://pppd/options.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: ppp
    - context:
        server_name: {{ server_name }}
{%- endfor %}
