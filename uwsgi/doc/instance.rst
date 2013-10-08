Pillar
======

Following pillar keys are used by many uWSGI instances (softwares that use
uWSGI as application server).

Mandatory
---------

None

Optional
--------

workers
~~~~~~~

number of uWSGI workers that will run the webapp.

timeout
~~~~~~~
how long in seconds until a uWSGI worker is killed while running a single
request. Default 30.

cheaper
~~~~~~~

number of process in uWSGI cheaper mode. Default no cheaper mode.
See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html

idle
~~~~

number of seconds after inactivity uWSGI will switch to cheap mode
(NOT cheaper mode).
