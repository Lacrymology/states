{#
 Turn off Iptables firewall
 #}
/etc/network/iptables.conf:
  file:
    - absent

iptables:
  file:
    - absent
    - name: /etc/iptables/rules.v4
  pkg:
    - purged
    - names:
      - iptables
      - iptstate
      - iptables-persistent

nf_conntrack_ftp:
   kmod:
     - absent
