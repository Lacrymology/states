{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/etc/nagios/nrpe.d/salt_archive-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/salt-archive.cfg:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('salt.archive.server') }}

/etc/sudoers.d/salt_archive_server_nrpe:
  file:
    - absent
