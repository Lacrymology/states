Firewall
========

All :ref:`glossary-smtp` clients need to be allowed to connect to the following
ports:

- :ref:`glossary-TCP` ``25``: :ref:`glossary-smtp`
- if :ref:`pillar-postfix-ssl` is set to ``True`` in :doc:`pillar`,
  :ref:`glossary-TCP` ``465``: Secure :ref:`glossary-smtp`.

