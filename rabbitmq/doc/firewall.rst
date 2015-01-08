Firewall
========

.. include:: /doc/include/add_firewall.inc

- If you turned on ``ssl`` in :doc:`pillar`:
  :doc:`/nginx/doc/index` :doc:`/nginx/doc/firewall`

All `AMQP <https://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol>`_
client need to be allowed to connect to the following port:

- :ref:`glossary-TCP` ``5672`` AMQP

Management can be allowed from some secured network to:

- :ref:`glossary-TCP` ``15672``: :doc:`index` management interface
- :ref:`glossary-TCP` ``55672``: :doc:`index` console
