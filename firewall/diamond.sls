{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{% if grains['virtual'] != 'openvzve' %}
include:
  - diamond
  - firewall
  - rsyslog.diamond

firewall_nf_conntrack_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/ConnTrackCollector.conf
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}

        enabled = True
        dir = /proc/sys/net/netfilter
        files = nf_conntrack_count,nf_conntrack_max
    - require:
      - file: /etc/diamond/collectors
      - kmod: firewall_nf_conntrack
    - watch_in:
      - service: diamond
{% endif %}
