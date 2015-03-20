Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/postfix/doc/index` :doc:`/postfix/doc/firewall`

The IMAP/POP server needs the following port open to anyone, based on
your security requirements (don't want cleartext):

- :ref:`glossary-TCP` ``143``: :ref:`glossary-imap`
  <https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol>`_
- :ref:`glossary-TCP` ``110``: :ref:`glossary-pop3`
- :ref:`glossary-TCP` ``993``: :ref:`glossary-imap` over :doc:`/ssl/doc/index`
- :ref:`glossary-TCP` ``995``: :ref:`glossary-pop3` over :doc:`/ssl/doc/index`
