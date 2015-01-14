..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Diep Pham <favadi@robotinfra.com>

Elasticsearch
=============

`Elasticsearch <http://www.elasticsearch.org>`_ is a flexible and powerful open
source, distributed, real-time search and analytics engine. Architected from the
ground up for use in distributed environments where reliability and scalability
are must haves, Elasticsearch gives you the ability to move easily beyond simple
full-text search. Through its robust set of :ref:`glossary-api`\s and query
:ref:`glossary-dsl`\s, plus clients for the most popular programming languages,
Elasticsearch delivers on the near limitless promises of search technology.

.. Copied from http://www.elasticsearch.org/overview/ on 2015-01-13

.. warning::

   Elasticsearch don't support :ref:`glossary-HTTP` over
   SSL/:ref:`glossary-HTTPS`.  The only way to secure access to admin interface
   over :ref:`glossary-HTTPS` is to proxy a :doc:`/ssl/doc/index` frontend in
   front of Elasticsearch :ref:`glossary-HTTP` interface.  This is why
   :doc:`/nginx/doc/index` is used if :doc:`/ssl/doc/index` is in :doc:`pillar`.

.. toctree::
    :glob:

    *
