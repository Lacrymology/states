{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Remove Nagios NRPE check for Salt-API Server.
-#}
/etc/nagios/nrpe.d/salt-api.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/salt-api-nginx.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('salt.api') }}
