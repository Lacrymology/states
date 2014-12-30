{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Lam Dang Tung <lam@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('openerp') }}

/etc/nagios/nrpe.d/openerp-uwsgi.cfg:
  file:
    - absent
{#-
/etc/nagios/nrpe.d/postgresql-openerp.cfg:
  file:
    - absent
#}
/etc/nagios/nrpe.d/openerp-nginx.cfg:
  file:
    - absent
