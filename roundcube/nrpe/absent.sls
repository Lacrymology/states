{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('roundcube') }}

/etc/nagios/nrpe.d/roundcube-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-roundcube.cfg:
  file:
    - absent
