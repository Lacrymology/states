Coding Style Guide
==================

:copyrights: Copyright (c) 2013, Bruno Clermont

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.
             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:authors: - Bruno Clermont

PIP
---

all package install by pip must be specified version number

Good::

  MySQL-python==1.2.4

Bad::

  MySQL-python


States
------

most of SLS should have its counter-part absent SLS. That means:

* if you have mariadb/server/init.sls, you should have mariadb/server/absent.sls
* absent state must not use same ID as init.sls or other SLS file, that will
  cause conflict when we include all them to test.

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

    {#
    blah blah blah
    hello 123
    #}
    log: syslog

* All config file must have a header tell that it's managed by salt (that string get from pillar)
* All config file must end with `.jinja2`
* Main config file should use name config.jinja2 instead of its_original_name.jinja2

Absent
------

absent formulas are mainly used by intergration.py script.

Some points to notice when write an absent formula:

* If it has a pip.remove state, make sure that states has low order
(often order: 1) because local.absent will remove /usr/local and therefore
remove /usr/local/bin/pip
