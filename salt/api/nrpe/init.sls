{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Nagios NRPE check for Salt-API Server.
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context -%}
{%- set ssl = salt['pillar.get']('salt_api:ssl', False) -%}
include:
  - apt.nrpe
  - git.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - rsyslog.nrpe
  - salt.master.nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('salt.api', pillar_prefix='salt_api', check_ssl_score=True) }}
