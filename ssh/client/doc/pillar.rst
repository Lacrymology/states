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
      myhost.com
        keys:
          key_name:
            nagios:
              - root
              - gitlab
            backup: backup
          another_key:
            root: backup
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
a host which including ``port``, ``fingerprint``, ``keys``, ``additional``,
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

.. _pillar-ssh-hosts-hostname-keys:

ssh:hosts:{{ hostname }}:keys
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Data in form::

    {{ keyname }}:
      {{ localuser1 }}: {{ remoteuser1 }}
      {{ localuser2 }}:
        - {{ remoteuser1 }}
        - {{ remoteuser2 }}
    {{ keyname2 }}:
      ...

``localuser`` is local Linux user, who will run ssh and use the managed key.
``remoteuser`` is remote :doc:`/ssh/doc/index` user on ``hostname``, which will
be logged in as. This can also be a list of remote users.
``keyname`` is defined key in :ref:`pillar-ssh-keys`.

Default: no data (``{}``).

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
:ref:`pillar-ssh-hosts` to use with that host. For key private content,
see :doc:`/ssh/doc/index`.

Default: Unused (``{}``).

.. _pillar-ssh-root_key:

ssh:root_key
~~~~~~~~~~~~

Content of :doc:`/ssh/doc/index` private key of ``root`` user.

Default: No private root key (``False``).
