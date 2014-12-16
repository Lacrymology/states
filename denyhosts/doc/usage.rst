Usage
=====

.. TODO: FIX

.. TODO: HERE DOCUMENT HOW TO REMOVE FROM BLACKLIST AN HOSTNAME

How to remove an IP address that DenyHosts blocked?
---------------------------------------------------

- Stop DenyHosts by running::

    service denyhosts stop

- Remove the lines that contains the blocked IP address from the following
  files:

  - ``/etc/hosts.deny``
  - ``/var/lib/denyhosts/hosts``
  - ``/var/lib/denyhosts/hosts-restricted``
  - ``/var/lib/denyhosts/hosts-root``
  - ``/var/lib/denyhosts/hosts-valid``
  - ``/var/lib/denyhosts/user-hosts``

- Start DenyHosts::

    service denyhosts start

Instead of doing 3 above steps manually, use this script
``/usr/local/bin/denyhosts-unblock`` to unblock one or more ip addresses
automatically::

    /usr/local/bin/denyhosts-unblock <ip_address> ...
