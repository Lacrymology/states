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
        public_keys:
          {{ long gpg keyid }}: |
            {{ Max public key }}
          7907B85E3DDDE757: |
            -----BEGIN PGP PUBLIC KEY BLOCK-----
            Version: GnuPG v1

            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
            =3zdr
            -----END PGP PUBLIC KEY BLOCK-----
        private_keys:
          {{ long gpg keyid }}: |
            {{ private gpg key}}

``public_keys`` is dictionary with key is long :doc:`index` keyid, value is its
public key contents. To get long :doc:`index` keyid, use following command::

  gpg --list-public-keys --with-colons

.. warning::

   All public keys exist in key chain but aren't specified in the
   ``public_keys`` dictionary above will be deleted.

Default: manage no user (``{}``).
