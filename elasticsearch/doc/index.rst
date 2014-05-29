Elasticsearch
=============

Install an Elasticsearch NoSQL server or cluster.

Elasticsearch don't support HTTP over SSL/HTTPS.
The only way to secure access to admin interface over HTTPS is to proxy
a :doc:`/ssl/doc/index` frontend in front of Elasticsearch HTTP interface.
This is why :doc:`/nginx/doc/index` is used if :doc:`/ssl/doc/index`
is in :doc:`pillar`.

.. toctree::
    :glob:

    *
