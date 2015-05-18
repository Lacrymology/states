Pillar
======

Mandatory
---------

Optional
--------

gnupg:users
~~~~~~~~~~~

Dictionary contains users and :doc:`index` public keys to import.

Example::

  gnupg:
    users:
      John:
        import_keys:
          Max: {{ Max public key }}
          Owen: {{ Owen public key }}
        delete_keys:
          Ronaldo: {{ Ronaldo public key }}

``import_keys`` is list of :doc:`index` public keys to import.
``delete_keys`` is list of :doc:`index` public keys to delete.

Default: manage no user (``{}``).
