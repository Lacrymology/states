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

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  ssh:
    server:
      ports:
        - 22
        - 22022
      extra_configs:
        - RhostsRSAAuthentication no
        - HostbasedAuthentication no
        - RSAAuthentication yes
        - PubkeyAuthentication yes
        - KeyRegenerationInterval 3600
        - SyslogFacility AUTH
        - LogLevel INFO
        - LoginGraceTime 120
        - PermitRootLogin yes
        - StrictModes yes
        - IgnoreRhosts yes
        - PermitEmptyPasswords no
        - X11Forwarding no
        - X11DisplayOffset 10
        - PrintLastLog yes
        - TCPKeepAlive yes

ssh:server:ports
~~~~~~~~~~~~~~~~

List of SSH port that allowed.

Default: ``[22]``

ssh:server:extra_configs
~~~~~~~~~~~~~~~~~~~~~~~~

List extra configurations for :doc:`index`.

See more in
`SSH man <http://www.openbsd.org/cgi-bin/man.cgi?query=sshd_config&sektion=5>`__.

Default: Empty list (``[]``).

.. warning::

  Some formula such as :doc:`/git/server/doc/index`, :doc:`/gitlab/doc/index`
  and :doc:`/salt/archive/server/doc/index` requires some users allowed to
  log in.
