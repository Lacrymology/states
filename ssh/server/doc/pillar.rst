Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  ssh:
    server:
      root_keys:
        santos:
          AAAAB3NzaC1yc2EAAAADAQABAAABAQDB+hcS+d/V0cmEDX9zv07jXcH+b5DB4YD9ptx0kVtpfkQWc+TtYH/eY2jmTXUZWVx+kfn5qDI3Ojq9jRgfgM0tuICqTW78Vi2P4Qd5ektFkkAa9ERhhZRMzi0tbpQdyOQxEkflh3Upmuwm+im9Y4TdWNvVO3cM+DOCH1JNpEgh5OGo52/Tq/FUgzt750Ls1/QPzbmkgUYd9SmEknrS/dHm9XRm5D0RumQzW75CniuyZEx+Gn/C/+h+mHapBCXizUZEK9+y7er9MOmHTZ5Er9tb/bc6k7cQYXVzIGqLm8ENV1SYeSwxuTsPrvTsBGHqURBAnz3OllQD2yws5XmmIJ2L: ssh-rsa
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

List of SSH port that :doc:`index` listens on.

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
  and :doc:`/salt/archive/doc/index` requires some users allowed to log in.

.. _pillar-ssh-server-root_keys:

ssh:server:root_keys
~~~~~~~~~~~~~~~~~~~~

SSH public keys to allow login with root user.

Structure::

  root_keys:
    human name:
      ssh public key: type
      another ssh public key: another type

Default: do not allow to login by any public key (``{}``).

.. _pillar-root_keys-user:

ssh:server:root_keys:{{ user }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Data formed as a dictionary ``pubkey``:``type``.

Default: ``{}``.
