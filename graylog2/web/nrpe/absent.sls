{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
/etc/nagios/nrpe.d/graylog2-web.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/graylog2-nginx.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('graylog2.web') }}
