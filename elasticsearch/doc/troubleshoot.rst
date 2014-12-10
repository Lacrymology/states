Troubleshooting
===============

Clustering
----------

Start the first instance, you should see something along the lines of::

  [2013-12-11 02:23:34,245][INFO ][cluster.service          ]
  [my-node-1] new_master
  [my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true},
  reason: zen-disco-join (elected_as_master)

and on the second node::

  [2013-12-11 02:23:40,498][INFO ][cluster.service          ]
  [my-node-2] detected_master
  [my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.1
  57:9300]]{master=true}, added
  {[my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true},},
  reason: zen-disco-receive(from master [
  [my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true}])

switch back to the first node::

  [2013-12-11 02:23:42,522][INFO ][cluster.service          ]
  [my-node-1] added
  {[my-node-2][URdBoFeFRKim3N-UYGxgCQ][inet[/10.128.213.252:9300]]
  {master=true},}, reason: zen-disco-receive(join from
  node[[my-node-2][URdBoFeFRKim3N-UYGxgCQ][inet[/10.128.213.252:9300]]{master=true}])

.. TODO: NO REAL USAGE OF IT.
.. TODO: PLEASE LINK TO ES OFFICIAL DOC.
