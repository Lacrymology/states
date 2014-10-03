.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

.. include:: /doc/include/support.inc

Mandatory
---------

Example::

  apt:
    sources: |
      deb http://mirror.anl.gov/pub/ubuntu/ {{ grains['oscodename'] }} main
      restricted universe multiverse
      deb http://security.ubuntu.com/ubuntu {{ grains['oscodename'] }}-security
      main restricted universe multiverse
      deb http://archive.canonical.com/ubuntu {{ grains['oscodename'] }} partner

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

apt:upgrade
~~~~~~~~~~~

Whether you want to refresh apt database and upgrade all packages or not.

Default: ``False``.

proxy_server
~~~~~~~~~~~~

If ``True``, the specific
`HTTP proxy server <https://en.wikipedia.org/wiki/Proxy_server#Web_proxy_servers>`_
(without authentication) is used to download ``.deb`` and reach
`APT <http://en.wikipedia.org/wiki/Advanced_Packaging_Tool>`_ server.

Default: ``False``.

packages:blacklist
~~~~~~~~~~~~~~~~~~

List of packages to keep uninstalled.

Default: None (``[]``).

packages:whitelist
~~~~~~~~~~~~~~~~~~

List of packages to keep installed.

Default: None (``[]``).
