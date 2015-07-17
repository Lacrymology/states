Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

sysctl
------

:doc:`/sysctl/doc/index` :doc:`/sysctl/doc/pillar` need to have at least the
following::

  sysctl:
    net.ipv4.ip_forward: 1

Mandatory
---------

Example::

  strongswan:
    ca:
      name: example
      days: 365
      common_name: example-ca
      country: US
      state: California
      locality: Redwood City
      organization: My Company Ltd
      organizational_unit: IT
      email: info@example.com
    secret_types:
      eap:
        user: pass

.. _pillar-strongswan-ca-name:

strongswan:ca:name
~~~~~~~~~~~~~~~~~~

Name of the Certificate Authority.

.. _pillar-strongswan-ca-days:

strongswan:ca:days
~~~~~~~~~~~~~~~~~~

Number of days the Certificate Authority will be valid.

.. _pillar-strongswan-ca-country:

strongswan:ca:country
~~~~~~~~~~~~~~~~~~~~~

Country name.

.. _pillar-strongswan-ca-state:

strongswan:ca:state
~~~~~~~~~~~~~~~~~~~

State or Province Name.

.. _pillar-strongswan-ca-locality:

strongswan:ca:locality
~~~~~~~~~~~~~~~~~~~~~~

Locality Name.

.. _pillar-strongswan-ca-organization:

strongswan:ca:organization
~~~~~~~~~~~~~~~~~~~~~~~~~~

Organization Name.

.. _pillar-strongswan-ca-organizational_unit:

strongswan:ca:organizational_unit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Organizational Unit Name.

.. _pillar-strongswan-ca-common_name:

strongswan:ca:common_name
~~~~~~~~~~~~~~~~~~~~~~~~~

The certificate `Common Name <http://info.ssl.com/article.aspx?id=10048>`_.

.. _pillar-strongswan-ca-email:

strongswan:ca:email
~~~~~~~~~~~~~~~~~~~

Email Address.

.. _pillar-strongswan-secret_types:

strongswan:secret_types
~~~~~~~~~~~~~~~~~~~~~~~

A dict of secret types with key is the type and value maybe is another dict of
username and password.

.. _pillar-strongswan-secret_types-type:

strongswan:secret_types:{{ type }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A dict of username and password of the ``{{ type }}`` of secret.

.. _pillar-strongswan-rightsourceip_pools:

strongswan:rightsourceip_pools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of pools in :ref:`glossary-CIDR` notation.

Optional
--------

Example::

  strongswan:
    ca:
      bits: 2048
    public_interface: eth0
    clients:
      ios: 456
    dns_servers:
      - 208.67.222.222

.. _pillar-strongswan-ca-bits:

strongswan:ca:bits
~~~~~~~~~~~~~~~~~~

Number of RSA key bits.

Default: ``2048`` bit :ref:`glossary-RSA`.

.. _pillar-strongswan-public_interface:

strongswan:public_interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The network interface which will be used for connecting from other end.

Default: use the value from :ref:`pillar-network-interface` (``False``).

.. _pillar-strongswan-clients:

strongswan:clients
~~~~~~~~~~~~~~~~~~

Data formed as a dictionary with key is the name of the client certificate and
value is the password of :ref:`glossary-pkcs12` certificate file.

Default: just support Android, no extra clients (``{}``).

.. _pillar-strongswan-dns_servers:

strongswan:dns_servers
~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`glossary-DNS` servers that will be assigned to peer via
mode-config (IKEv1) or configuration payload (IKEv2).

Default: uses Google :ref:`glossary-DNS` (``['8.8.8.8', '8.8.4.4']``).

.. note::

   This list must not include a client named ``server`` which will override
   the server certificate.
