Style guide
========

pip
---

all package install by pip must be specified version number

Good::

  MySQL-python==1.2.4

Bad::

  MySQL-python


states
-----

most of SLS should have its counter-part absent SLS. That means ::

    * if you have mariadb/server/init.sls, you should have mariadb/server/absent.sls

    * absent state must not use same ID as init.sls or other SLS file, that will
      cause conflict when we include all them to test

use only standard style to write state.

Good::

  mariadb-server:
    pkg:
      - installed

Bad::

  mariadb-server:
    pkg.installed


States should be group together if it make sense::

Good::

  mariadb-server:
    pkg:
      - installed
    service:
      - running
      - name: mysql
      - require:
        - pkg: mariadb-server

Not so good::

  mariadb-server:
    pkg:
      - installed

  mariadb-service:
    service:
      - running
      - name: mysql
      - require:
        - pkg: mariadb-server


Grains
-------

States should use grains when possible:


Good::

    salt:
      file:
        - absent
        - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_release'] }}.list

Bad::

  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt-precise.list


Pillar
-------

All user data must be embeded to SLS using pillar

Good::
   bind: {{ salt['pillar.get']('mysql:bind', '127.0.0.1') }}

Bad::
   bind: 127.0.0.1

Configs
--------

All app/daemon log must be send to syslog or graylog2 (if support)

All comment must be commented by jinja2 comment. User should only get a config
file with no comment


This means::

    # blah blah blah
    # hello 123
    log: syslog

Should be ::
    {#
    blah blah blah
    hello 123
    #}
    log: syslog

* All config file must have a header tell that it's managed by salt (that string get from pillar)

* All config file must end with `.jinja2`

* Main config file should use name config.jinja2 instead of its_original_name.jinja2

