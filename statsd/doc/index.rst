..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

StatsD
======

Introduction
------------

StatsD is originally a simple daemon developed and released by Etsy to
aggregate and summarize application metrics. With StatsD, applications are to
be instrumented by developers using language-specific client libraries. These
libraries will then communicate with the StatsD daemon using its dead-simple
protocol, and the daemon will then generate aggregate metrics and relay them to
virtually any graphing or monitoring backend.

.. https://www.datadoghq.com/2013/08/statsd/ - 2015-01-23

.. note::

   The server was written in Node.js but this formula will install the Python
   version. Moreover, `py-statsd <https://github.com/Jonty/py-statsd>`_ will be
   used instead of `pystatsd <https://github.com/sivy/pystatsd>`_ as it support
   sending `Gauges
   <http://statsd.readthedocs.org/en/latest/types.html#gauges>`_ metric.

Links
-----

* `Python implementation of StatsD <https://pypi.python.org/pypi/statsd/>`_.
* `Original implementation of StatsD <https://github.com/etsy/statsd>`_
   in :doc:`/nodejs/doc/index`.
* `Gauges support implementation of StatsD
  <https://github.com/Jonty/py-statsd>`_.

Related Formulas
----------------

* :doc:`/python/doc/index`
* :doc:`/rsyslog/doc/index`

Content
-------

.. toctree::
    :glob:

    *
