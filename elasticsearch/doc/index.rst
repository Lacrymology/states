..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Van Pham Diep <favadi@robotinfra.com>

Elasticsearch
=============

More can be find at official `Elasticsearch page <http://www.elasticsearch.org>`_.

Install an Elasticsearch NoSQL server or cluster.

Elasticsearch don't support :ref:`glossary-HTTP` over SSL/:ref:`glossary-HTTPS`.
The only way to secure access to admin interface over :ref:`glossary-HTTPS` is to proxy
a :doc:`/ssl/doc/index` frontend in front of Elasticsearch :ref:`glossary-HTTP` interface.
This is why :doc:`/nginx/doc/index` is used if :doc:`/ssl/doc/index`
is in :doc:`pillar`.

.. toctree::
    :glob:

    *
