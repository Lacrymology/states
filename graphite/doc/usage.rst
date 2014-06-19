.. Copyright (c) 2009, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     * Redistributions of source code must retain the above copyright notice,
..       this list of conditions and the following disclaimer.
..     * Redistributions in binary form must reproduce the above copyright
..       notice, this list of conditions and the following disclaimer in the
..       documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

.. TODO: FIX

Usage
=====

Web UI
------

After installing, you can login to the :doc:`/graphite/doc/index` web by using
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

`Full list of function <http://graphite.readthedocs.org/en/latest/functions.html>`__

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
