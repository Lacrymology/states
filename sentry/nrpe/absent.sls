{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>

Remove Nagios NRPE check for Sentry.
-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('sentry') }}

/etc/nagios/nrpe.d/sentry-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-sentry.cfg:
  file:
    - absent
