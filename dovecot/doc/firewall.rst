Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/postfix/doc/index` :doc:`/postfix/doc/firewall`

The IMAP/POP server need to get the following port open to anyone, based on your
security requirements (don't want cleartext):

- ``TCP`` ``143``: `IMAP <https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol>`__
- ``TCP`` ``110``: `POP3 <https://en.wikipedia.org/wiki/Pop3>`__
- ``TCP`` ``993``: IMAP over :doc:`/ssl/doc/index`
- ``TCP`` ``995``: POP3 over :doc:`/ssl/doc/index`
