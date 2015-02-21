{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('pdnsd') }}

/etc/sudoers.d/pdnsd_nrpe:
  file:
    - absent

/usr/lib/nagios/plugins/check_dns_caching.py:
  file:
    - absent

{{ opts['cachedir'] }}/pip/pydns:
  file:
    - absent
