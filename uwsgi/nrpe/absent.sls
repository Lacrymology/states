{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('uwsgi') }}

/etc/sudoers.d/nagios_uwsgi:
  file:
    - absent

/etc/sudoers.d/nrpe_uwsgi:
  file:
    - absent

/usr/local/bin/uwsgi-nagios.sh:
  file:
   - absent

/usr/lib/nagios/plugins/check_uwsgi:
  file:
    - absent

/usr/lib/nagios/plugins/check_uwsgi_nostderr:
  file:
    - absent

