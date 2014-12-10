Firewall
========

.. include:: /doc/include/add_firewall.inc

- If you turned on ``ssl`` in :doc:`pillar`:
  :doc:`/nginx/doc/index` :doc:`/nginx/doc/firewall`

All `AMQP <https://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol>`__
client need to be allowed to connect to the following port:

- ``TCP`` ``5672`` AMQP

Management can be allowed from some secured network to:

- ``TCP`` ``15672``: :doc:`index` management interface
- ``TCP`` ``55672``: :doc:`index` console
