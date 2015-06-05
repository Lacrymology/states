Pillar
======

sysctl
------

:doc:`/sysctl/doc/index` :doc:`/sysctl/doc/pillar` need to have at least the
following::

  sysctl:
    net.ipv4.ip_forward: 1

ppp
---

:doc:`/pppd/doc/index` :doc:`/pppd/doc/pillar` need to have at least the
following::

  pppd:
    instances:
      xl2tpd:
        ... values ...
