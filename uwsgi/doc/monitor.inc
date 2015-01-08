|deployment|\_uwsgi_master
~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor |deployment| :doc:`/uwsgi/doc/index` master process.

Critical:

  * There is no |deployment|-master process running
  * There are more than one |deployment|-master processes running

|deployment|\_uwsgi_worker
~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor |deployment| :doc:`/uwsgi/doc/index` worker processes.  The
maximum number of woker processes running is specified with
``pillar_prefix:workers`` pillar key.

If ``pillar_prefix:cheaper`` pillar key is defined, there are always at
least this number of workers running |deployment|.

Critical:

  * If ``pillar_prefix:cheaper`` is defined

    - There are less than ``pillar_prefix:cheaper`` number of
      ``pillar_prefix-woker`` processes running

    - There are more than ``pillar_prefix:workers`` number of
      ``pillar_prefix-woker`` processes running

  * If ``pillar_prefix:cheaper`` is undefined

    - There are not exactly ``pillar_prefix:workers`` number of
      ``pillar_prefix-woker`` processes running

|deployment|\_uwsgi_ping
~~~~~~~~~~~~~~~~~~~~~~~~

Check |deployment| :doc:`/uwsgi/doc/index` response via UNIX socket.
