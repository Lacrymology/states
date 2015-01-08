Firewall
========

All SMTP client need to be allowed to connect to the following port:

- :ref:`glossary-TCP` ``25``: `SMTP <https://en.wikipedia.org/wiki/Smtp>`_.
- if :ref:`pillar-postfix-ssl` is set to ``True`` in :doc:`pillar`,
  :ref:`glossary-TCP` ``465``: Secure SMTP.
