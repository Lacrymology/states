Usage
=====

Web UI
------

After installing, you can login to the Graphite web by using the account that
is defined in pillar ``graphite:web:initial_admin_user``.

LINK TO PILLAR DOC

Here you can see all the metrics, such as those that Diamond LINK TO DIAMOND DOC
sent to Carbon under: Graphite -> `Your minion name` -> ``os``.

A few functions to get the data you want: 

- **sumSeries()**: aggregating events from different sources into one series,
  for e.g::
    
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

Cleanup Metrics
---------------

You can manually remove saved metric, such as for removing destroyed host by
remove the folder from the file-system of the carbon server::

  /var/lib/graphite/whisper/$MINION

Where ``$MINION`` is the minion ID of the host you want to remove.
