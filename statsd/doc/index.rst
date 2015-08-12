..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

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

   The server was written in :doc:`/nodejs/doc/index` but this formula
   will install the :doc:`/go/doc/index` version.

Links
-----

* `Golang implementation of StatsD <https://github.com/bitly/statsdaemon>`_.
* `Original implementation of StatsD <https://github.com/etsy/statsd>`_
   in :doc:`/nodejs/doc/index`.

Related Formulas
----------------

* :doc:`/rsyslog/doc/index`

Content
-------

.. toctree::
    :glob:

    *
