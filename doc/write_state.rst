.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Coding Style Guide
==================

Terminology
-----------

- Formula is a collection of SLS files, that often locate inside same
  directory, and is used to provide a software and all supported integration
  (:doc:`/nrpe/doc/index`, :doc:`/diamond/doc/index`).
- SLS (stands for SaLt State file) is a file that ends with .sls extension.
  Which often consists of multiple states.
- State is a salt-state, which is a representation of the state that a system
  should be in.
- State module is a python module, which is responsible for system will be
  in the declared state. For example, ``file`` state module is a
  `python module <https://github.com/saltstack/salt/blob/develop/salt/states/file.py>`__
  or ``/usr/share/pyshared/salt/states/file.py`` on Ubuntu OS. It is responsilbe
  for a file will be managed, with user/group and mode set to what user
  declared in his state.

PIP
---

all package install by ``pip`` must be specified version number

Good::

  MySQL-python==1.2.4

Bad::

  MySQL-python

Requirements file should be ``file.managed`` and have ``pip.install`` module run
only if they're changed.

If the Python environment destination is the root (``/usr/local``), it's
filename should be ``{{ opts['cachedir'] }}/pip/$statename``.
If it's in a virtualenv it should be ``/usr/local/$venv/salt-requirements.txt``.

States
------

most of SLS should have its counter-part absent SLS. That means:

* if you have ``mariadb/server/init.sl``s, you should have
  ``mariadb/server/absent.sls``
* absent state must contain some state IDs like in ``init.sls`` , that will
  cause conflict when we include both ``init.sls`` and ``absent.sls`` of a
  formula, which is a situation that should never happen.

Use only standard style to write state.

Good::

  mariadb-server:
    pkg:
      - installed

Bad::

  mariadb-server:
    pkg.installed

States should be group together if it make sense:

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
------

States should use grains when possible:


Good::

    salt:
      file:
        - absent
        - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_distrib_release'] }}.list

Bad::

  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt-precise.list


Pillar
------

All user data must be embeded to SLS using pillar

Good::

   bind: {{ salt['pillar.get']('mysql:bind', '127.0.0.1') }}

Bad::

   bind: 127.0.0.1

Configs
-------

All app/daemon log must be send to syslog or graylog2 (if support).

All comment must be commented by jinja2 comment. User should only get a config
file with no comment.


This means::

    # blah blah blah
    # hello 123
    log: syslog

Should be ::

    {#-
    blah blah blah
    hello 123
    #}
    log: syslog

* All config file must have a header tell that it's managed by salt (that string
  get from pillar)
* All config file must end with ``.jinja2``
* Main config file should use name ``config.jinja2`` instead of
  ``its_original_name.jinja2``

Absent
------

absent formulas are mainly used by ``integration.py`` script.

Some points to notice when write an absent formula:

* If it has a pip.remove state, make sure that states has low order
  (often order: 1) because local.absent will remove ``/usr/local`` and therefore
  remove ``/usr/local/bin/pip``

Installing
----------

* App that installed used an alternate method than ``apt-get`` should be located
  in ``/usr/local/software_name``
* Using ppa is prefered to self-compile software from source.

Upgrading
---------

* Make sure formula will work with an existing-running-service and a
  new-clean-install-server. (Remove old version and install new, or just
  install then restart service, or does it need a manually migrating process?)

* Contact person that in charge of making local mirror for that software
  (ppa repo, deb files, pip package, etc...)
