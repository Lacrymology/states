Hack Salt in your Sandbox
=========================

Installation
------------

You need ZeroMQ dev libraries to build Python binding, in Ubuntu::

  # apt-get install libzmq-dev

Then create a virtualenv::

  $ virtualenv salt
  $ source salt/bin/activate

Then checkout salt code and install it::

  $ pip install -e git+https://github.com/saltstack/salt.git@0.16#egg=salt

Master
------

Make your virtualenv able to run salt master::

  $ mkdir -p conf/pki/master
  $ mkdir -p cache/master
  $ mkdir -p run/master
  $ mkdir pillar

Create configuration file ``conf/master`` (replace ``$YOURUSERNAME`` and
``/path/to``)::

  worker_threads: 1
  keep_jobs: 999999
  open_mode: True
  auto_accept: True
  log_file: /dev/stdout
  log_level: garbage
  log_datefmt_logfile: '%Y-%m-%d %H:%M:%S'
  pidfile: /path/to/salt/run/master/pid
  sock_dir: /path/to/salt/run/master
  pki_dir: /path/to/salt/conf/pki/master
  cachedir: /path/to/salt/cache/master
  user: $YOURUSERNAME
  pillar_roots:
    base:
      - /path/to/salt/pillar

This documentation file is located in ``salt-common`` repository. Let's
assume that you already cloned it.

If you only need ``salt-common``, set the specific value::

  file_roots:
    base:
      - /absolute/path/to/salt-common

Unless you need also a *non-common* repository::

  file_roots:
    base:
      - /absolute/path/to/salt-common
      - /absolute/path/to/salt-non-common

You can now run the master::

  $ bin/salt-master -c /path/to/salt/conf

Master (and also minion) run in foreground without threading and
multi-processing to make it easy to run in a debugger and see the logs.

Minion
------

Create

Now for salt-minion::

  $ mkdir conf/pki/minon
  $ mkdir cache/minion
  $ mkdir run/minion

Create configuration file ``conf/minion`` (replace ``$YOURUSERNAME``
and ``/path/to``)::

  master: 127.0.0.1
  id: minion
  multiprocessing: False
  worker_threads: 1
  pillar_opts: False
  log_file: /dev/stdout
  log_level: garbage
  log_datefmt_logfile: '%Y-%m-%d %H:%M:%S'
  user: $YOURUSERNAME
  pidfile: /path/to/salt/run/minion/pid
  sock_dir: /path/to/salt/run/minion
  pki_dir: /path/to/salt/conf/pki/minion
  cachedir: /path/to/salt/cache/minion

For each states repos you will works with, add them to all 3 directives::

  module_dirs:
    - /absolute/path/to/salt-common/_modules
    - /absolute/path/to/salt-non-common/_modules
  states_dirs:
    - /absolute/path/to/salt-common/_states
    - /absolute/path/to/salt-non-common/_states
  returner_dirs:
    - /absolute/path/to/salt-common/_returners
    - /absolute/path/to/salt-non-common/_returners

You can now run the minion::

  $ bin/salt-minion -c /path/to/salt/conf

You can test communication between master and minion with::

  $ bin/salt -c /path/to/salt/conf minion test.ping
  minion:
      True

To run some state without having the master running you can use ``salt-call``
passing it the `--local` switch::

  $ bin/salt -c/path/to/salt/conf --local minion test.ping

Salt API
--------

If you need to use Salt API, follow the next steps.

Install
~~~~~~~

Use pip to install in your virtualenv::

  $ pip install salt-api==0.8.2
  $ pip install cherrypy

Configure
~~~~~~~~~

Add to ``conf/master`` (replace ``$YOURUSERNAME``)::

  rest_cherrypy:
    port: 8000
    debug: True
  external_auth:
    pam:
      $YOURUSERNAME:
        - .*

Stop (with a single CTRL-C) and start salt-master process.

Run salt-api::

  $ salt-api -c /path/to/salt/conf

Test
~~~~

.. note::

  The following don't seem to works on newer version of salt-api anymore.

You can test salt-api using curl (replace ``$YOURUSERNAME`` and
``$YOURUNIXPASSWORD``)::

  $ curl -sS localhost:8000/run \
    -H 'Accept: application/x-yaml' \
     -d client='local' \
     -d tgt='*' \
     -d fun='test.ping' \
     -d username='$YOURUSERNAME' \
     -d password='$YOURUNIXPASSWORD' \
     -d eauth='pam'

Result should be::

  return:
    - minion: true

Overriding default paths
------------------------

When you get tired of passing ``-c /path/to/salt/conf`` to every call you can do
the following:

If you installed salt with ``pip -e`` as per this docs, go to
``/path/to/salt/repo`` which by default will be in ``/path/to/salt/src/salt``
and edit ``salt/syspaths.py``

Do the following changes:

* change ``ROOT_DIR = '/'`` for ``ROOT_DIR = '/path/to/salt'``
* change ``CONFIG_DIR = os.path.join(ROOT_DIR, 'etc', 'salt')`` for
  ``CONFIG_DIR = os.path.join(ROOT_DIR, 'conf')``

If you installed salt without ``-e`` do those changes in ``salt/_syspaths.py``
instead
