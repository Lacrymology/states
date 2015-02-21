{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/nagios/nrpe.d/salt-api.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/salt-api-nginx.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('salt.api') }}
