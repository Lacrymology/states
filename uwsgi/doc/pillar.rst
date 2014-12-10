Pillar
======

Following pillar keys are used by many :doc:`index` instances (softwares that
use :doc:`index` as application server).

Optional
--------

.. _pillar-workers:

workers
~~~~~~~

Number of :doc:`index` workers that will run the webapp.

.. _pillar-timeout:

timeout
~~~~~~~

How long in seconds until a :doc:`index` worker is killed while running a single
request.

Default ``30``.

.. _pillar-cheaper:

cheaper
~~~~~~~

Number of process in :doc:`index`
`cheaper mode <http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html>`__

Default: cheaper mode isn't used.

.. _pillar-idle:

idle
~~~~

Number of seconds after inactivity :doc:`index` will switch to cheap mode
(NOT cheaper mode).

Default: no idling.
