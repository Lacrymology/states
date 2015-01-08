Pillar
======

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
            nagios:
              - root
              - gitlab
            backup: backup
      - contents: |
         ...
        map:
          www.bleh.com:

    root_key: |
        -----BEGIN RSA PRIVATE KEY-----
        MIIEdsfadsfsdaXXXXXXXXXXX...
        -----END RSA PRIVATE KEY-----

.. _pillar-ssh-known_hosts:

ssh:known_hosts
~~~~~~~~~~~~~~~

`Known hosts <http://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files#.7E.2F.ssh.2Fknown_hosts>`_ that will added to ``.ssh/known_hosts``.
Data formed as a dictionary ``domain_name``:``server public key``
with server public key can be obtained by run ``ssh-keyscan domain``

Example::

    $ ssh-keyscan github.com
    # github.com SSH-2.0-OpenSSH_5.9p1 Debian-5ubuntu1+github5
    github.com ssh-rsa
    AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==

The public key of `github.com <https://github.com>`_ is ``AAAAB......aQ==``.
Though, prefix the key with ``github.com ssh-rsa`` still valid and improve
redability.

.. note::

  github.com and `bitbucket.org <https://bitbucket.org>`_ public keys are
  already managed by this formula as they are often required by other one.

Default: no custom known hosts (``{}``).

.. _pillar-ssh-keys:

ssh:keys
~~~~~~~~

List of key mapping, each map use below structure::

  contents: |
        {{ PRIVATE_KEY }}
  map:
    {{ address }}:
      {{ localuser1 }}: {{ remoteuser1 }}
      {{ localuser2 }}:
        - {{ remoteuser1 }}
        - {{ remoteuser2 }}


For private content, see :doc:`/ssh/doc/index`

Use address of remote host (domain or IP) for ``address``
``localuser`` is linux user, who will run ssh and use the managed key.
``remoteuser`` is linux user on ``address``, which will be logged in as. This
can also be a list of remote users.

If no ``localuser``:``remoteuser`` provided, use ``root``:``root``

Default: Unused (``[]``).

.. _pillar-ssh-root_key:

ssh:root_key
~~~~~~~~~~~~

Content of :doc:`/ssh/doc/index` private key of ``root`` user.

Default: No private root key (``False``).
