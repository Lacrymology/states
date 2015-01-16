{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Nagios NRPE check for Shinken.
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - virtualenv.nrpe
{% if salt['pillar.get']('shinken:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('shinken.broker', pillar_prefix='shinken', check_ssl_score=True) }}
