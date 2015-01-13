{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - erlang.nrpe
  - logrotate.nrpe
  - nrpe
  - nginx.nrpe
{%- if salt['pillar.get']('rabbitmq:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('rabbitmq', check_ssl_score=True) }}
