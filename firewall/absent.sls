{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/etc/network/iptables.conf:
  file:
    - absent

iptables_reset_to_defaults:
  cmd:
    - script
    - source: salt://firewall/reset.sh
    - onlyif: iptables --version

iptables:
  file:
    - absent
    - name: /etc/iptables/rules.v4
    - require:
      - cmd: iptables_reset_to_defaults
  pkg:
    - purged
    - pkgs:
      - iptables
      - iptstate
      - iptables-persistent
    - require:
      - cmd: iptables_reset_to_defaults

nf_conntrack_ftp:
   kmod:
     - absent

/etc/rsyslog.d/firewall.conf:
  file:
    - absent
