Pillar
======

Optional
--------

Example::

  ssh:
   known_hosts:
     git.robotinfra.com:
       fingerprint: c9:fb:62:8b:d3:b6:c8:7d:33:6b:65:9f:e2:9d:a2:71
       port: 22022
  deployment_key:
    contents: |
        -----BEGIN RSA PRIVATE KEY-----
       MIIEdsfadsfsdaXXXXXXXXXXX...
       -----END RSA PRIVATE KEY-----
   type: rsa

ssh:known_hosts
~~~~~~~~~~~~~~~

List known hosts that will added to .ssh/known_hosts.

Default: ``git.robotinfra.com`` by default of that pillar key.

ssh:known_hosts:fingerprint
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Host's fingerprint.

Default: ``c9:fb:62:8b:d3:b6:c8:7d:33:6b:65:9f:e2:9d:a2:71``
by default of that pillar key.

ssh:known_hosts:port
~~~~~~~~~~~~~~~~~~~~

Host's port for ssh access.

Default: ``22022`` by default of that pillar key.

deployment_key:contents
~~~~~~~~~~~~~~~~~~~~~~~

SSH private key content.

deployment_key:type
~~~~~~~~~~~~~~~~~~~

Type of SSH private key.

