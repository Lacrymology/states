{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - virtualenv.nrpe

{{ passive_check('statsd') }}
