Metrics
=======

See ProcessResources collector :doc:`document </diamond/doc/process>`.

Processes:

* openvpn

OpenVPN
-------

Locate at ``os > openvpn`` in graphite web interface.

{{ instance }}.clients.connected
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of current connected users to :doc:`/openvpn/doc/index`
instance.

{{ instance }}.global.auth_read_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{{ instance }}.global.tcp-udp_read_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`/openvpn/doc/index` instance has read via
TCP/UDP in bytes.

{{ instance }}.global.tcp-udp_write_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`/openvpn/doc/index` instance has written
via TCP/UDP in bytes.

{{ instance }}.global.tun-tap_read_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`/openvpn/doc/index` instance has read via
TUN/TAP device in bytes.

{{ instance}}.global.tun-tap_write_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`/openvpn/doc/index` instance has written
via TUN/TAP device in bytes.
