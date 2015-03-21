Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  ssh:
    users:
      root:
        - keyname
        - keyname2
    hosts:
      github.com:
        fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
      myhost.com:
      anotherhost.com:
        port: 22022
    forgot_hosts:
      bitbucket.org:
    keys:
      key_name: |
            -----BEGIN RSA PRIVATE KEY-----
            MIIEowIBAAKCAQEA3wk5tqR1i...
            -----END RSA PRIVATE KEY-----
      another_key: |
            -----BEGIN RSA PRIVATE KEY-----
            LDJLJFLAKFJdlfj...
            -----END RSA PRIVATE KEY-----
      root_key: |
          -----BEGIN RSA PRIVATE KEY-----
          MIIEdsfadsfsdaXXXXXXXXXXX...
          -----END RSA PRIVATE KEY-----

.. _pillar-ssh-hosts:

ssh:hosts
~~~~~~~~~

Data of hosts that this :doc:`index` can connect to.
Data formed as a nested dictionary. Each sub dictionary contains data about
a host which including ``port``, ``fingerprint``, ``additional``,
which all are described below.

Default: no managed host (``{}``).

.. _pillar-ssh-hosts-hostname-port:

ssh:hosts:{{ hostname }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which port of ``hostname`` will be used to check for hostkey.

Default: (``22``).

.. _pillar-ssh-hosts-hostname-fingerprint:

ssh:hosts:{{ hostname }}:fingerprint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fingerprint of remote ``hostname`` which will be checked when that ``hostname``
be managed as
`known host <http://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files#
.7E.2F.ssh.2Fhosts>`_.

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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

Map of key name and key private content. These keys can be used in
:ref:`pillar-ssh-users` to use with that user. For key private content,
see :doc:`/ssh/doc/index`.

Default: Unused (``{}``).

.. _pillar-ssh-users:

ssh:users
~~~~~~~~~

User mapping to ssh key. Data in form of::

    {{ local_user }}:
      - {{ keyname }}
      - {{ keyname2 }}

``localuser`` is local Linux user, who will run ssh and use the managed key.
``keyname`` is defined key in :ref:`pillar-ssh-keys`.

Default: no user is managed (``{}``).
