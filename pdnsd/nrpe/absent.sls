{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>

-#}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('pdnsd') }}

/etc/sudoers.d/pdnsd_nrpe:
  file:
    - absent

/usr/lib/nagios/plugins/check_dns_caching.py:
  file:
    - absent

{{ opts['cachedir'] }}/pip/pydns:
  file:
    - absent
