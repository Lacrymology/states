{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Nagios NRPE check for Shinken Arbiter.
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
  - pip.nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - ssmtp.nrpe
  - virtualenv.nrpe
{% if salt['pillar.get']('shinken:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('shinken.arbiter', pillar_prefix='shinken') }}
