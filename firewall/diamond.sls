{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{% if grains['virtual'] != 'openvzve' %}
include:
  - diamond
  - kernel.modules
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
      - file: kernel_modules
    - watch_in:
      - service: diamond
{% endif %}
