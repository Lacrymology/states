{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - sudo
  - sudo.nrpe

{{ passive_check("dhcp.server") }}

/etc/sudoers.d/dhcp-server:
  file:
    - managed
    - template: jinja
    - source: salt://dhcp/server/nrpe/sudo.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: sudo
    - require_in:
      - service: nagios-nrpe-server
