{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - nrpe
  - sudo
  - sudo.nrpe

/etc/sudoers.d/check_dhcp:
  file:
    - managed
    - source: salt://dhcp/client/nrpe/sudo.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo
    - require_in:
      - service: nagios-nrpe-server

{{ passive_check('dhcp.client') }}
