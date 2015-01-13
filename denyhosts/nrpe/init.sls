{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - denyhosts
  - nrpe
  - pysc.nrpe
  - rsyslog.nrpe

{{ passive_check('denyhosts') }}
