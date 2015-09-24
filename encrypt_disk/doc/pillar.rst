Pillar
======

.. include:: /doc/include/add_pillar.inc


Optional
--------

Example::

  encrypt_disk:
    /dev/sda1:
      block: /mnt/toaster
      key: XXX
      bind:
        - /root/.gnupg

.. _pillar-encrypt_disk:

encrypt_disk
~~~~~~~~~~~~

Contains information to do disks encryption.

Default: ``{}``.

encrypt_disk:{{ disk }}:passphrase
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Passphrase use to encrypt disk.

Default: don't encrypt disk (``False``).

encrypt_disk:{{ disk }}:fstype
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Type of filesystem to format the :ref:`glossary-LUKS` device.

Default: ``ext4``.

.. _pillar_encrypt_disk-disk-block:

encrypt_disk:{{ disk }}:block
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Mount point to mount the :ref:`glossary-LUKS` device to.

Default: don't mount (``False``).

encrypt_disk:{{ disk }}:bind
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of directories to mount with bind option as a sub directory inside
:ref:`pillar_encrypt_disk-disk-block`. Only valid if
:ref:`pillar_encrypt_disk-disk-block` is defined.

Default: ``[]``.
