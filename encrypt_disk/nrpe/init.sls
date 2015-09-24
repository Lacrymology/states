{#- Usage of this is governed by a license that can be found in doc/license.rst #}
include:
  - nrpe
  - sudo
  - sudo.nrpe

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{{ passive_check('encrypt_disk') }}

/etc/sudoers.d/nrpe_encrypt_disk:
  file:
    - managed
    - template: jinja
    - source: salt://encrypt_disk/nrpe/sudo.jinja2
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: sudo
    - require_in:
      - pkg: nagios-nrpe-server
