{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Remove Nagios NRPE check for tomcat.
-#}
/etc/nagios/nrpe.d/tomcat.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('tomcat.6', file_name='tomcat') }}
