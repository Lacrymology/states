Firewall
========

http
----

All web apps in this set of states do have their interface is reachable through
:doc:`/nginx/doc/index` on port ``80/tcp``.

https
-----

It also support :doc:`/ssl/doc/index` on port ``443/tcp``.

If ``ssl`` is defined in app pillar, the port ``443`` is also reachable.
If ``ssl_redirect`` pillar is set to `True` then any connection to
`HTTP <https://en.wikipedia.org/wiki/Http>`__ port
``80`` are automatically redirected to HTTPS port ``443``.
