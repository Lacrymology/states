Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  ssh:
    hosts:
      github.com:
        fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
      anotherhost.com:
        port: 22022
    forgot_hosts:
      bitbucket.org:
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

.. _pillar-ssh-hosts:

ssh:hosts
~~~~~~~~~~~~~~~

`Known hosts <http://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files#
.7E.2F.ssh.2Fhosts>`_ that will be managed.
Data formed as list of dictionaries, which in turn has structure:
``domain_name:{'port': PORT_NUMBER, 'fingerprint': FINGERPRINT}``.
``port`` and ``fingerprint`` can be omitted.

Default: no known host (``{}``).

.. _pillar-ssh-hosts-hostname-port:

ssh:hosts:{{ hostname }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which port of ``hostname`` will be used to check for hostkey.

Default: (``22``).

.. _pillar-ssh-hosts-hostname-fingerprint:

ssh:hosts:{{ hostname }}:fingerprint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using this pillar to avoid :doc:`/ssh/doc/index` to ``hostname`` when
it is compromised, which might changed host fingerprint.
Also avoid :ref:`glossary-DNS` attack, which may point domain
of ``hostname`` to another host.

Fingerprint can be obtained by following steps::

    $ ssh-keyscan github.com > /tmp/github_hostkey
    # github.com SSH-2.0-libssh-0.6.0
    $ ssh-keygen -lf /tmp/github_hostkey
    2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48 github.com (RSA)

Default: no set (``None``).

.. _pillar-ssh-hosts-hostname-additional:

ssh:hosts:{{ hostname }}:additional
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of additional :doc:`/ssh/doc/index` configuration for ``hostname``.

Default: no additional configuration (``[]``).

.. _pillar-ssh-forgot_hosts:

ssh:forgot_hosts
~~~~~~~~~~~~~~~~

Hosts to be removed from list of known hosts. Must not already provided
in :ref:`pillar-ssh-hosts`.

Default: no remove any known host (``{}``).

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
``localuser`` is local Linux user, who will run ssh and use the managed key.
``remoteuser`` is remote :doc:`/ssh/doc/index` user on ``address``, which will
be logged in as. This can also be a list of remote users.

If no ``localuser``:``remoteuser`` provided, use ``root``:``root``

Default: Unused (``[]``).

.. _pillar-ssh-root_key:

ssh:root_key
~~~~~~~~~~~~

Content of :doc:`/ssh/doc/index` private key of ``root`` user.

Default: No private root key (``False``).
