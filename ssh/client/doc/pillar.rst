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

ssh:known_hosts:fingerprint
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Host's fingerprint.

ssh:known_hosts:port
~~~~~~~~~~~~~~~~~~~~

Host's port for ssh access.

deployment_key:contents
~~~~~~~~~~~~~~~~~~~~~~~

SSH private key content.

deployment_key:type
~~~~~~~~~~~~~~~~~~~

Type of SSH private key.

