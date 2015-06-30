Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Mandatory
---------

Example::

  openvpn_client:
    server_instance: devops

.. _pillar-openvpn_client-server_instance:

openvpn_client:server_instance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which :doc:`/openvpn/server/doc/index` instance that client will connect to.

Conditional
-----------

.. _pillar-openvpn_client-instance-ca:

openvpn_client:{{ instance }}:ca
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :ref:`glossary-CA` content that is generated on the server then inject
into pillar via `external pillars
<http://docs.saltstack.com/en/latest/topics/development/external_pillars.html>`_

.. _pillar-openvpn_client-instance-crt:

openvpn_client:{{ instance }}:crt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The client certificate.

.. _pillar-openvpn_client-instance-key:

openvpn_client:{{ instance }}:key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The client private key.

.. _pillar-openvpn_client-instance-conf:

openvpn_client:{{ instance }}:conf
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The content of the client configuration file.
