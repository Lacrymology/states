{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('openerp') }}

/etc/nagios/nrpe.d/openerp-uwsgi.cfg:
  file:
    - absent
{#-
/etc/nagios/nrpe.d/postgresql-openerp.cfg:
  file:
    - absent
#}
/etc/nagios/nrpe.d/openerp-nginx.cfg:
  file:
    - absent
