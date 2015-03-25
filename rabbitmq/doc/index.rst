..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

RabbitMQ
========

Introduction
------------

:doc:`index` is open source message broker software (sometimes called
message-oriented middleware) that implements the `Advanced Message Queuing
Protocol (AMQP) <http://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol>`_.
The :doc:`index` server is written in the :doc:`/erlang/doc/index` programming
language and is built on the Open Telecom Platform framework for clustering and
fail-over. Client libraries to interface with the broker are available for all
major programming languages.

.. https://www.rabbitmq.com

Clustering
----------

In this formula, the term 'master' is used to mention the only node in cluster
which will install addition stuffs for monitoring, management, performing
necessary actions (create vhost, user, etc, ...) for the whole cluster.

Links
-----

* `RabbitMQ Homepage <https://www.rabbitmq.com/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/RabbitMQ>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/erlang/doc/index`
* :doc:`/ssl/doc/index`
* :doc:`/nginx/doc/index`

Content
-------

.. toctree::
    :glob:

    *
