.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     * Redistributions of source code must retain the above copyright notice,
..       this list of conditions and the following disclaimer.
..     * Redistributions in binary form must reproduce the above copyright
..       notice, this list of conditions and the following disclaimer in the
..       documentation and/or other materials provided with the distribution.
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

Pillar
======

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

Content of sources.list file as multiline pillar.
Don't use HTTPS URLs, as ubuntu 12.04 `apt-transport-https` does not support
many HTTPS SSL certificate properly.

Optional
--------

Example::

  packages:
    blacklist:
      - more
      - vi
    whitelist:
      - vim
      - cmon
      - nmap

proxy_server
~~~~~~~~~~~~

If True, the specific HTTP proxy server (without authentication) is used to
download .deb and reach APT server.

Default: ``False``.

packages:blacklist
~~~~~~~~~~~~~~~~~~

List of packages to keep uninstalled.

Default: None (``[]``).

packages:whitelist
~~~~~~~~~~~~~~~~~~

List of packages to keep installed.

Default: None (``[]``).
