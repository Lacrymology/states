{#-
 Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - logrotate.nrpe
  - mongodb.nrpe
  - nginx.nrpe
  - nrpe
  - rsyslog.nrpe
{% if salt['pillar.get']('graylog2:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - sudo.nrpe

{{ passive_check('graylog2.web', pillar_prefix='graylog2', check_ssl_score=True) }}
