{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Remove Nagios NRPE check for Salt Master.
-#}
/etc/nagios/nrpe.d/salt-master.cfg:
  file:
    - absent

/etc/sudoers.d/nrpe_salt_mine:
  file:
    - absent

/etc/sudoers.d/nrpe_salt_master:
  file:
    - absent

salt_mine_collect_minions_data:
  file:
    - name: /etc/cron.twice_daily/salt_mine_data
    - absent

/etc/cron.d/salt_mine_data:
  file:
    - absent

/usr/lib/nagios/plugins/check_mine_minions.py:
  file:
    - absent
    - require:
      - file: salt_mine_collect_minions_data

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('salt.master') }}
