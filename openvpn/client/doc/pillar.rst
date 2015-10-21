Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

.. note::

   All of these are generated on the :doc:`/openvpn/server/doc/index` then
   inject into pillar via `external pillars
   <http://docs.saltstack.com/en/latest/topics/development/external_pillars.html>`_.
   No need to define manually.

Mandatory
---------

.. _pillar-openvpn_client-instances:

openvpn_client:instances
~~~~~~~~~~~~~~~~~~~~~~~~

A dictionary with key is the :doc:`/openvpn/server/doc/index` instance that
client will connect to and value is another dictionary of ``ca``, ``crt``,
``key``, ``conf``.

Conditional
-----------

.. _pillar-openvpn_client-instances-instance-ca:

openvpn_client:instances:{{ instance }}:ca
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :ref:`glossary-CA` content of the :doc:`/openvpn/server/doc/index`
{{ instance }}.

.. _pillar-openvpn_client-instances-instance-crt:

openvpn_client:instances:{{ instance }}:crt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The client certificate to connect to :doc:`/openvpn/server/doc/index`
{{ instance }}.

.. _pillar-openvpn_client-instances-instance-key:

openvpn_client:instances:{{ instance }}:key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The client private key to connect to :doc:`/openvpn/server/doc/index`
{{ instance }}.

.. _pillar-openvpn_client-instances-instance-conf:

openvpn_client:instances:{{ instance }}:conf
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The content of the client configuration file to connect to
:doc:`/openvpn/server/doc/index` {{ instance }}.
