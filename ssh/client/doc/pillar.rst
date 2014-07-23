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
    known_hosts:
      github.com: github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    keys:
      - contents: |
            -----BEGIN RSA PRIVATE KEY-----
            MIIEowIBAAKCAQEA3wk5tqR1i...
            -----END RSA PRIVATE KEY-----
        map:
          ci.example.com:
          alerts.example.com:
            nagios: root
            backup: backup
      - contents: |
         ...
        map:
          www.bleh.com:

  deployment_key:
    contents: |
       -----BEGIN RSA PRIVATE KEY-----
       MIIEdsfadsfsdaXXXXXXXXXXX...
       -----END RSA PRIVATE KEY-----
    type: rsa

ssh:known_hosts
~~~~~~~~~~~~~~~

Known hosts that will added to ``.ssh/known_hosts``.
Data formed as a dictionary ``domain_name``:``server public key``
with server public key can be obtained by run ``ssh-keyscan domain``

Example::

    $ ssh-keyscan github.com
    # github.com SSH-2.0-OpenSSH_5.9p1 Debian-5ubuntu1+github5
    github.com ssh-rsa
    AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==

The public key of `github.com <https://github.com>`__ is ``AAAAB......aQ==``.
Though, prefix the key with ``github.com ssh-rsa`` still valid and improve
redability.

.. note::
  github.com and `bitbucket.org <https://bitbucket.org>`__ public keys are
  already managed by this formula as they are often required by other one.

ssh:keys
~~~~~~~~

List of key mapping, each map use below structure::

  contents: |
        {{ PRIVATE_KEY }}
  map:
    {{ address }}:
      {{ localuser1 }}: {{ remoteuser1 }}
      {{ localuser1 }}: {{ remoteuser1 }}


For private content, see :doc:`/ssh/doc/index`

Use address of remote host (domain or IP) for ``address``
``localuser`` is linux user, who will run ssh and use the managed key.
``remoteuser`` is linux user on ``address``, which will be logged in as.

If no ``localuser``:``remoteuser`` provided, use ``root``:``root``

deployment_key:contents
~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/ssh/doc/index` private key content.

deployment_key:type
~~~~~~~~~~~~~~~~~~~

Type of :doc:`/ssh/doc/index` private key: ``rsa`` or ``dsa``.
