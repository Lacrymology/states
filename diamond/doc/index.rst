Diamond
=======

.. TODO
.. More can be find at official `Amavisd page`_.

Diamond is a :doc:`/python/doc/index` daemon that collects system metrics and
publishes them to :doc:`/graphite/doc/index` (and others). It is capable of
collecting CPU, memory, network, I/O, load and disk metrics. Additionally, it
features an API for implementing custom collectors for gathering metrics from
almost any source.

It also plug with third party daemon such as :doc:`/postgresql/doc/index` to
gather those stats as well.

.. toctree::
    :glob:

    *
