Pillar
======

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

.. _pillar-ssh-server-ports:

ssh:server:ports
~~~~~~~~~~~~~~~~

List of SSH port that :doc:`/ssh/server/doc/index` listens on.

Default: Port ``[22]``

.. _pillar-ssh-server-extra_configs:

ssh:server:extra_configs
~~~~~~~~~~~~~~~~~~~~~~~~

List extra configurations for :doc:`index`.

See more in
`SSH man <http://www.openbsd.org/cgi-bin/man.cgi?query=sshd_config&sektion=5>`_.

Default: No extra configs will be used (``[]``).

.. warning::

  Some formula such as :doc:`/git/server/doc/index`, :doc:`/gitlab/doc/index`
  and :doc:`/salt/archive/doc/index` requires some users allowed to
  log in.
