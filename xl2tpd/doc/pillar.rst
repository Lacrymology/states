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

:doc:`/ppp/doc/index` :doc:`/ppp/doc/pillar` need to have at least the
following::

  ppp:
    instances:
      xl2tpd:
        ... values ...
