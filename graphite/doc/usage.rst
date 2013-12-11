Installing Graphite
===================

Salt minion
-----------

Follow the instruction in the `doc/minion_installation.rst` to install Salt
minion.

Carbon
------

Carbon is a backend storage application. The role of it is to receive the data
from the agents and make that data available for real-time graphing.

You can install by running::

  salt q-graphite state.sls carbon -v

Read more: http://graphite.readthedocs.org/en/latest/feeding-carbon.html

Graphite
--------

Run the following command on the Salt master to install Graphite::

  salt q-graphite state.sls graphite -v

Diamond
-------

Graphite only store time-series data and render graphs, it does not collect data for you. Here we use Diamond to collects system metric and send them to Graphite.

For simplicity, I am going to install Diamond on the same machine that is running Graphite::

  salt q-graphite state.sls diamond -v

Check the `netstat` output to make sure that Diamond connected to the carbon-relay::

  tcp        0      0 127.0.0.1:2004          127.0.0.1:53951         ESTABLISHED 14927/python
  tcp        0      0 127.0.0.1:53951         127.0.0.1:2004          ESTABLISHED 19747/python

For other tools that work with Graphite, see:
https://graphite.readthedocs.org/en/latest/tools.html

Using Graphite
==============

After installing, you can login to the Graphite web by using the account that
is defined in pillar::

  graphite:
    web:
      initial_admin_user:
        username: admin
        password: pass

Here you can see all the metrics that Diamond sent to Carbon under: Graphite -> q-graphite -> os.

A few functions to get the data you want: 

- **sumSeries()**: aggregating events from different sources into one series, for e.g::
    
    sum(shinken-*.os.cpu.total.system)

- **summarize()**: aggregates the values into "buckets" of a specific time
  interval::

    summarize(alerts.stats.sentry.response.200,"1mon")

- **asPercent()**: takes two series, returns the value of one compared to the
  other as percent::

    asPercent(elasticsearch-1.os.network.eth0.tx_byte,
    elasticsearch-2.os.network.eth0.tx_byte)

- **timeShift()**: correlate the activity betwen now and the same time in the
  past::

    timeShift(ci.os.loadavg.01,"1w")

- **mostDeviant()**: accept an integer N, averages the entire series, and
  filter out the top N deviant metrics from the overall average::

    mostDeviant(3,*.os.memory.MemFree)    

Full list: http://graphite.readthedocs.org/en/latest/functions.html
