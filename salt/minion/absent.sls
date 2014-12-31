{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Uninstall Salt Minion (client).
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('salt-minion') }}

/etc/cron.daily/salt_highstate:
  file:
    - absent

extend:
  salt-minion:
    file:
      - absent
      - name: /etc/salt/minion
      - require:
        - pkg: salt-minion
