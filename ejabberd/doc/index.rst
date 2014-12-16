Ejabberd
========

:doc:`/ejabberd/doc/index` is a `Jabber/XMPP
<http://en.wikipedia.org/wiki/XMPP>`_ instant messaging server,
licensed under GPLv2 (Free and Open Source), written in `Erlang/OTP
</erlang/doc/index>`_. Among other features, ejabberd is
cross-platform, fault-tolerant, clusterable and modular.

Security Issue
--------------

There is no way to disable SSLv3 in version 2.1.10 without re-compiling the
source code. This is a dirty hack, so leave it like that until there is
a build for Ubuntu that fix it.

.. toctree::
    :glob:

    *
