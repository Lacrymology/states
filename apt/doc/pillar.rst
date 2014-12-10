Pillar
======

.. include:: /doc/include/support.inc

Mandatory
---------

Example::

  apt:
    sources: |
      deb http://mirror.anl.gov/pub/ubuntu/ {{ salt['grains.get']('oscodename') }} main
      restricted universe multiverse
      deb http://security.ubuntu.com/ubuntu {{ salt['grains.get']('oscodename') }}-security
      main restricted universe multiverse
      deb http://archive.canonical.com/ubuntu {{ salt['grains.get']('oscodename') }} partner

.. _pillar-apt-sources:

apt:sources
~~~~~~~~~~~

Content of `APT sources.list <https://help.ubuntu.com/community/SourcesList>`__
file as multiline pillar.

Don't use `HTTPS <https://en.wikipedia.org/wiki/Https>`__
`URL <http://en.wikipedia.org/wiki/Uniform_resource_locator>`__, as Ubuntu 12.04
``apt-transport-https`` does not support
many :doc:`/ssl/doc/index` certificate properly.

Optional
--------

Example::

  apt:
    upgrade: True

  packages:
    blacklist:
      - more
      - vi
    whitelist:
      - vim
      - cmon
      - nmap

.. _pillar-apt-upgrade:

apt:upgrade
~~~~~~~~~~~

Whether to refresh :doc:`/apt/doc/index` database and upgrade all packages.

Default: do not refresh and upgrade (``False``).

.. _pillar-apt-proxy_server:

apt:proxy_server
~~~~~~~~~~~~~~~~

If ``True``, the specific
`HTTP proxy server <https://en.wikipedia.org/wiki/Proxy_server#Web_proxy_servers>`_
(without authentication) is used to download ``.deb`` and reach
`APT <http://en.wikipedia.org/wiki/Advanced_Packaging_Tool>`_ server.

Default: not use a proxy (``False``).

.. _pillar-packages-blacklist:

packages:blacklist
~~~~~~~~~~~~~~~~~~

List of packages to keep uninstalled.

Default: no package (``[]``).

.. _pillar-packages-whitelist:

packages:whitelist
~~~~~~~~~~~~~~~~~~

List of packages to keep installed.

Default: no package (``[]``).
