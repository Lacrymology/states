{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Nagios NRPE check for Carbon.
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - cron.nrpe
  - pysc.nrpe
  - graphite.common.nrpe
  - nrpe
  - logrotate.nrpe
  - pip.nrpe
  - python.dev.nrpe

{{ passive_check('carbon') }}
