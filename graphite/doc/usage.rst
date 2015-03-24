Usage
=====

.. TODO: FIX

Web UI
------

After installing, you can login to the :doc:`index` web by using
the account that is defined in :doc:`pillar`
``graphite:initial_admin_user``.

Here you can see all the metrics, such as those that :doc:`/diamond/doc/index`
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

`Full list of function
<http://graphite.readthedocs.org/en/latest/functions.html>`_

Cleanup Metrics
---------------

You can manually remove saved metric, such as for removing destroyed host by
remove the folder from the file-system of the carbon server::

  /var/lib/graphite/whisper/$MINION

Where ``$MINION`` is the :doc:`/salt/minion/doc/index` ID of the host you want
to remove.

Create user
-----------

To create user, you can login to the Django Administration Web ``/admin/`` URL
of :doc:`pillar` in one of the value of ``graphite:hostnames``.
by using the account that is defined in :doc:`pillar`
``graphite:initial_admin_user``.

Click `Users` at `Auth` section. Then put `Username`, `Password`,
`Password confirmation`. And click `Save` if you want to stop that, click
`Save and add another` if you want to continue to add another user or click
`Save and continue editing` if you want to edit.
