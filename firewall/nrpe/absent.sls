{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
/etc/sudoers.d/nrpe_firewall:
  file:
    - absent

/usr/local/bin/check_firewall.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_firewall.py:
  file:
    - absent

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('firewall') }}

