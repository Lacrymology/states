Pillar
======

Optional
--------

Example::

  ssh:
    server:
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

ssh:server:extra_configs
~~~~~~~~~~~~~~~~~~~~~~~~

List extra configurations for ssh server.

See more: http://www.manpagez.com/man/5/sshd_config/

Default: Empty list.

