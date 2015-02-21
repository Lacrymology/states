{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/sudoers.d/nrpe_firewall:
  file:
    - absent

/usr/local/bin/check_firewall.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_firewall.py:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('firewall') }}

