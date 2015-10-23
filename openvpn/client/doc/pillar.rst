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
    instances:
      devops:
        device: tap1

.. _pillar-openvpn_client-instances:

openvpn_client:instances
~~~~~~~~~~~~~~~~~~~~~~~~

A dictionary with key is the :doc:`/openvpn/server/doc/index` instance that
client will connect to and value is another dictionary of ``device``, ``ca``,
``crt``, ``key``, ``conf``.

.. _pillar-openvpn_client-instances-instance-device:

openvpn_client:instances:{{ instance }}:device
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`pillar-openvpn-servers-instance-device` but on the client side.

Make sure that it is unique when there are multiple instances running on a
machine.

.. note::

   All of the below are generated on the :doc:`/openvpn/server/doc/index` then
   inject into pillar via `external pillars
   <http://docs.saltstack.com/en/latest/topics/development/external_pillars.html>`_.
   No need to define manually.

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
