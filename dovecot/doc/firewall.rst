Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/postfix/doc/index` :doc:`/postfix/doc/firewall`

The IMAP/POP server need to get the following port open to anyone, based on your
security requirements (don't want cleartext):

- :ref:`glossary-TCP` ``143``: `IMAP <https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol>`_
- :ref:`glossary-TCP` ``110``: `POP3 <https://en.wikipedia.org/wiki/Pop3>`_
- :ref:`glossary-TCP` ``993``: IMAP over :doc:`/ssl/doc/index`
- :ref:`glossary-TCP` ``995``: POP3 over :doc:`/ssl/doc/index`
