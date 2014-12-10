Diamond
=======

.. TODO: BETTER INTRO

Diamond is a :doc:`/python/doc/index` daemon that collects system metrics and publishes them to
Graphite (and others). It is capable of collecting CPU, memory, network, I/O,
load and disk metrics. Additionally, it features an API for implementing custom
collectors for gathering metrics from almost any source.

It also plug with third party daemon such as :doc:`/postgresql/doc/index` to gather
those stats as well.

Each of those other daemons state come with their own configuration file
that are put in ``/etc/diamond/collectors``, directory check at startup for
additional configurations.

.. toctree::
    :glob:

    *
