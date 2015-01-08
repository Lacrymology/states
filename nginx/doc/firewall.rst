Firewall
========

http
----

All web apps in this set of states do have their interface is reachable through
:doc:`/nginx/doc/index` on port :ref:`glossary-TCP` ``80``.

https
-----

It also support :doc:`/ssl/doc/index` on port :ref:`glossary-TCP` ``443``.

If ``ssl`` is defined in app pillar, the port ``443`` is also reachable.
If ``ssl_redirect`` pillar is set to ``True`` then any connection to
:ref:`glossary-HTTP` port
``80`` are automatically redirected to :ref:`glossary-HTTPS` port ``443``.