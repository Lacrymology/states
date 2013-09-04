Hack Salt in your Sandbox
=========================

Installation
------------

First, you need to know that we're on 0.15.x branch, as 0.16.x don't work with
our current states.

You need ZeroMQ dev libraries to build Python binding, in Ubuntu::

  # apt-get install libzmq-dev

Then create a virtualenv::

  $ virtualenv salt
  $ source salt/bin/activate

Then checkout salt code and install it::

  $ mkdir salt/src
  $ (cd salt/src; git clone -b 0.15 https://github.com/saltstack/salt.git)
  $ pip install -e src/salt

Master
------

Make your virtualenv able to run salt master::

  $ mkdir -p conf/pki/master
  $ mkdir -p cache/master
  $ mkdir -p run/master
  $ mkdir states
  $ mkdir pillar

Create configuration file ``conf/master`` (replace $YOURUSERNAME and /path/to)::

  worker_threads: 1
  keep_jobs: 999999
  open_mode: True
  auto_accept: True
  log_file: file:///dev/stdout
  log_level: garbage
  user: $YOURUSERNAME
  log_datefmt_logfile: '%Y-%m-%d %H:%M:%S'
  pidfile: /path/to/salt/run/master/pid
  sock_dir: /path/to/salt/run/master
  pki_dir: /path/to/salt/conf/pki/master
  cachedir: /path/to/salt/cache/master
  file_roots:
    base:
    - /path/to/salt/states
  pillar_roots:
    base:
    - /path/to/salt/pillar
  rest_cherrypy:
    port: 8000
    debug: True
  external_auth:
    pam:
      $YOURUSERNAME:
        - .*

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

Create configuration file ``conf/minion``(replace $YOURUSERNAME and /path/to)::

  master: 127.0.0.1
  id: minion
  multiprocessing: False
  worker_threads: 1
  log_file: file:///dev/stdout
  log_level: garbage
  log_datefmt_logfile: '%Y-%m-%d %H:%M:%S'
  user: $YOURUSERNAME
  pidfile: /path/to/salt/run/minion/pid
  sock_dir: /path/to/salt/run/minion
  pki_dir: /path/to/salt/conf/pki/minion
  cachedir: /path/to/salt/cache/minion

You can now run the minion::

  $ bin/salt-minion -c /path/to/salt/conf

You can test communicationb between master and minion with::

  $ bin/salt -c ~/salt/conf minion test.ping
  minion:
      True

Salt API
--------

Install salt-api::

  $ pip install -e salt-api==0.8.2
  $ pip install cherrypy

Run salt-api::

  $ salt-api -c /path/to/salt/conf

You can test salt-api using curl (replace user pass)::

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
