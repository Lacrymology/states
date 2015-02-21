{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('djangopypi2') }}

/etc/nagios/nrpe.d/djangopypi2-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-djangopypi2.cfg:
  file:
    - absent

