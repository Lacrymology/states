Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

.. _pillar-ppp-debug:

pppd:debug
~~~~~~~~~~

Turns on (more) debugging to syslog.

Default: no debugging (``False``).

.. _pillar-ppp-instances:

pppd:instances
~~~~~~~~~~~~~~

Data formed as a dictionary with key is the instance name and value is a dict.

Default: no instance (``{}``).

.. _pillar-ppp-instances-instance:

pppd:instances:{{ instance }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Define some options of an :doc:`index` instance. Look below for details.

Default: no option (``{}``).

.. _pillar-ppp-instances-instance-dns:

pppd:instances:{{ instance }}:dns
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Specify a list of IP addresses of :ref:`glossary-DNS` servers.

If :doc:`index` is acting as a server for Microsoft Windows clients, this option allows
:doc:`index` to supply one or two :ref:`glossary-DNS` addresses to the clients.  The
first instance of this option specifies the primary :ref:`glossary-DNS`
address; the second instance (if given) specifies the secondary
:ref:`glossary-DNS` address.

.. warning::

  This information may not be taken into account by a Windows
  client. See KB311218 in Microsoft's knowledge base for more information.

Default: no DNS server (``[]``).

.. _pillar-ppp-instances-instance-wins:

pppd:instances:{{ instance }}:wins
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If :doc:`index` is acting as a server for Microsoft Windows or "Samba" clients, this
option allows :doc:`index` to supply one or two
http://en.wikipedia.org/wiki/Windows_Internet_Name_Service (WINS) server
addresses to the clients.  The first instance of this option specifies the
primary WINS address; the second instance (if given) specifies the secondary
WINS address.

Default: no WINS server (``[]``).

.. _pillar-ppp-instances-instance-encryption:

pppd:instances:{{ instance }}:encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Data formed as a dictionary with key is ``refuse`` or ``require`` and value is
the encryption mechanism.

Default: no encryption (``{}``).

.. note::

   If ``mppe-128`` is defined here, then it requires an additional pillar key
   in :ref:`pillar-kernel-modules`::

     kernel:
       modules:
         - ppp_mppe

.. _pillar-ppp-instances-instance-encryption-refuse:

pppd:instances:{{ instance }}:encryption:refuse
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of encryption mechanism refused.

Default: ``('pap', 'chap', 'mschap')``

- ``pap``: http://en.wikipedia.org/wiki/Password_authentication_protocol
- ``chap``: http://en.wikipedia.org/wiki/Challenge-Handshake_Authentication_Protocol
- ``mschap``: https://en.wikipedia.org/wiki/MS-CHAP

.. _pillar-ppp-instances-instance-encryption-require:

pppd:instances:{{ instance }}:encryption:require
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of encryption mechanism required.

Default: ``('mschap-v2',)``

- ``mschap-v2``: https://en.wikipedia.org/wiki/MS-CHAP

pppd:instances:{{ instance }}:options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of additional :doc:`index` options to add to configuration files.

Example::

  pppd:
    instances:
      pptpd:
        - nobsdcomp

Default: no options (``[]``).
