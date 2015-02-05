Configuration file
==================

Here're the common steps to setup :doc:`/index`:

* Install OpenVPN client
* Copy the required files to the client machine
* Put it into a folder, then run the service

Depend on which authentication mode, the required files are different:

Static Key
----------

* ``/etc/openvpn/{{ instance  }}/client.conf``
* ``/etc/openvpn/{{ instance  }}/secret.key``

TLS
---

* ``/etc/openvpn/ca.crt``
* ``/etc/openvpn/{{ instance }}/{{ client_name }}.conf``
* ``/etc/openvpn/{{ instance }}/{{ instance }}_{{ client_name }}.crt``
* ``/etc/openvpn/{{ instance }}/{{ instance }}_{{ client_name }}.key``
