Metrics
=======

:doc:`/diamond/doc/process`:

* ``openvpn`` - :doc:`index`
* ``openvpn-backup-file``

OpenVPN
-------

Locate at ``os > openvpn``.

{{ instance }}.clients.connected
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of current connected users to :doc:`index` instance.

{{ instance }}.global.auth_read_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{{ instance }}.global.tcp-udp_read_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`index` instance has read via
:ref:`glossary-TCP`/:ref:`glossary-UDP` in bytes.

{{ instance }}.global.tcp-udp_write_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`index` instance has written via
:ref:`glossary-TCP`/:ref:`glossary-UDP` in bytes.

{{ instance }}.global.tun-tap_read_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`index` instance has read via
:ref:`glossary-TUN`/:ref:`glossary-TAP` device in bytes.

{{ instance}}.global.tun-tap_write_bytes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Total amount of data :doc:`index` instance has written via
:ref:`glossary-TUN`/:ref:`glossary-TAP` device in bytes.
