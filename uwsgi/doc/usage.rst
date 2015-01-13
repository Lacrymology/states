Usage
=====

How it works with Nginx
-----------------------

:doc:`/nginx/doc/index` interacts with :doc:`index` through a socket
(:ref:`glossary-TCP` or UNIX socket). When user send a request to
:doc:`/nginx/doc/index`, it follows the rule in its config file and if the rule
is ``pass_uwsgi``, it passes (writes to specified socket) that request to
:doc:`index`. :doc:`index` process the request (often to interpret
:doc:`/python/doc/index`, :doc:`/php/doc/index` or Ruby code), after that, it
returns HTML, write it to above socket, :doc:`/nginx/doc/index` reads it, does
some another process (e.g. adding HTTP headers) then returns to user.

Some following bits help correctly setting owner, permission for files:
  - both :doc:`/nginx/doc/index` worker process(es) and :doc:`index` worker
    process(es) need to read and write to socket by which they communicate.
  - :doc:`/nginx/doc/index` worker process(es) needs to read any files which it
    will serve directly (images, css, js ...) and any files it needs to pass to
    :doc:`index`.  So, :doc:`/nginx/doc/index` worker needs to read permission
    for the source code.
  - :doc:`index` worker process(es) needs to read the source code files to be
    able to interpret them.
  - If app supports user to upload file, it done by :doc:`/nginx/doc/index` so
    the directory for upload must writable for :doc:`/nginx/doc/index` worker.
  - If app write to any file, :doc:`index` does interpret those codes so
    :doc:`index` worker needs write permission to where it needs to write.
  - As ``www-data`` is often user who owns :doc:`/nginx/doc/index` process and
    it can be config to own :doc:`index` worker process too, if app does not
    need to write file and support upload. Then these config can be simplify by
    set all source code files to owned by user ``root`` and group ``www-data``,
    with read permission only (440).  Otherwise, a dedicated user can be used
    for uUWSGI. Write permission should only set to either who need to write.

Processes
---------

In ``emperor`` mode, :doc:`index` run with 2 processes with root user::

  root     30931  0.0  2.0  42856 10248 ?        Ssl  21:52   0:00 /usr/local/uwsgi-1.9.17.1/uwsgi --yaml /etc/uwsgi.yml
  root     30936  0.0  0.2  20568  1472 ?        S    21:52   0:00  \_ /usr/local/uwsgi-1.9.17.1/uwsgi --yaml /etc/uwsgi.yml
  1002     30939  0.0  2.0  44608 10568 ?        Sl   21:52   0:00      \_ roundcube-master
  1002     30941  0.0  1.0  33952  5440 ?        S    21:52   0:00          \_ roundcube-worker
  1002     30942  0.0  1.0  33952  5440 ?        S    21:52   0:00          \_ roundcube-worker

The ``roundcube-master`` process and all of its sub-processes owned by user
``1002``, which is configured by its instance config file with ``uid`` set to
``1002``. Numbers of worker can be set through instance config directive
``processes``.
