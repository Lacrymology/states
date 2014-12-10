Troubleshoot
============

.. TODO: FIX

Daemon
------

In case of problem, have a look at
``/var/log/upstart/graylog2-server.log``. This file exists when graylog2-server
produces log to stderr. Other graylog2-server output goes to
syslog (``/var/log/syslog``). Since :doc:`/graylog2/doc/index` is a logging server,
for troubleshooting it, one should look into these log files as its log
messages go nowhere than these files (you would not see them on graylog2-web
user interface).

Elasticsearch Cluster
---------------------

Check the log on the :doc:`/elasticsearch/doc/index` nodes to make sure that the graylog2-server
was discovered::

  [2013-12-11 02:27:20,308][INFO ][cluster.service          ]
  [q-elasticsearch-1] added
  {[q-graylog2][MZXCVbnLT4Wiq0dgxiWVvA][inet[/10.138.50.176:9300]]{client=
  true, data=false, master=false},}, reason: zen-disco-receive(join from
  node[[q-graylog2][MZXCVbnLT4Wiq0dgxiWVvA][inet[/10.138.50.176:9300]]{client=true,
  data=
  false, master=false}])

