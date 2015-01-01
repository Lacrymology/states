|deployment|\:workers
~~~~~~~~~~~~~~~~~~~~~

Maximum number of :doc:`index` workers that can be spawned to run |deployment|.

Default: ``1``.

|deployment|\:timeout
~~~~~~~~~~~~~~~~~~~~~

How long in seconds until a :doc:`index` worker is killed while running a single
request.

Default: ``60``.

|deployment|\:cheaper
~~~~~~~~~~~~~~~~~~~~~

Minimum number of processes will run in :doc:`index`
`cheaper mode <http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html>`__

Given value must less than (<) |deployment|:workers.

Default: ``False`` - not used.

|deployment|\:idle
~~~~~~~~~~~~~~~~~~

Number of seconds after inactivity :doc:`index` will switch to cheap mode
(NOT cheaper mode).

Default: ``300``, only use if |deployment|\:cheaper is turned on.
