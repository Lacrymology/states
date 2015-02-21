{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('etherpad') }}

/etc/nagios/nrpe.d/etherpad-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-etherpad.cfg:
  file:
    - absent

