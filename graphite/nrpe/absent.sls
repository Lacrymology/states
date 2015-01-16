{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('graphite') }}

/etc/nagios/nrpe.d/graphite-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-graphite.cfg:
  file:
    - absent
