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

Global Pillars
==============

The following Pillar values are commonly used across all states.

Required
--------

roles
~~~~~

List of roles that apply to a minion.
See :doc:`intro` and :doc:`usage` for details on roles.

Default: empty list ``[]``.

salt:master
~~~~~~~~~~~

As all deployed hosts are done trough salt, the minion need to know where is the
:doc:`/salt/master/doc/index` to connect.

Look in :doc:`/salt/minion/doc/index` for details.

message_do_not_modify
~~~~~~~~~~~~~~~~~~~~~

Warning message to not modify file.

Optional
--------

branch
~~~~~~

Which git branch to use during ``state.highstate``.

Default: ``master``.

files_archive
~~~~~~~~~~~~~

Path to :doc:`/salt/archive/server/doc/index` where download most files
(archives, packages, pip) to apply states.

graylog2_address
~~~~~~~~~~~~~~~~

IP/Hostname of centralized :doc:`/graylog2/server/doc/index` server.

graphite_address
~~~~~~~~~~~~~~~~

IP/Hostname of :doc:`/carbon/doc/index` server.
This key is required if ``diamond`` integration of formulas had been included in
roles.

shinken_pollers
~~~~~~~~~~~~~~~

List of monitoring hosts that can perform checks on this host.
This is required if any :doc:`/nrpe/doc/index` integration of formula had been
included in roles.

smtp
~~~~

Email server configuration.

Example::

  smtp:
    server: smtp.example.com
    port: 25
    domain: example.com
    from: joe@example.com
    user: yyy
    password: xxx
    authentication: plain
    encryption: plain

See below for details on each keys.

smtp:server
~~~~~~~~~~~

Your SMTP server. Ex: ``smtp.yourdomain.com``

smtp:port
~~~~~~~~~

SMTP server port.

smtp:domain
~~~~~~~~~~~

Domain name to use.

smtp:from
~~~~~~~~~

SMTP account use in FROM field.

smtp:user
~~~~~~~~~

SMTP account username, if applicable.

smtp:password
~~~~~~~~~~~~~

Password for account login, if specified user.

smtp:authentication
~~~~~~~~~~~~~~~~~~~

Authentication method. Default is: ``plain``.

smtp:encryption
~~~~~~~~~~~~~~~

SMTP encryption type.

Possible values: `SSL/TLS <http://en.wikipedia.org/wiki/Transport_Layer_Security>`_, `STARTTLS <http://en.wikipedia.org/wiki/Starttls>`_, ``plain``.

Default: ``plain``

encoding
~~~~~~~~

Default system locale.

Default: ``en_US.UTF-8``.

global_roles
~~~~~~~~~~~~

List of all available roles.

Default: automatically built by listing sub-directories of ``/roles``.

This key is usefull to restrict the list of available roles for an hosts.

roles_absent
~~~~~~~~~~~~

If ``True``, run the ``absent`` formula of each roles that the minion is not
assigned to.

Default: ``False``.

__test__
~~~~~~~~

If ``True`` the formulas consider themselves running trough the testing
framework. That pillar key must **NEVER** be defined in non-testing pillars.

And it must **ALWAYS** be defined and set to ``True`` in testing pillars.

Not following this rule will result in lost data and broken system.

Default: ``False``.

.. _root_keys:

root_keys
~~~~~~~~~

SSH public keys to allow login with root user.

Structure::

  root_keys:
    human name:
      ssh public key: type
      another ssh public key: another type

Example::

  root_keys:
    santos:
      AAAAB3NzaC1yc2EAAAADAQABAAABAQDB+hcS+d/V0cmEDX9zv07jXcH+b5DB4YD9ptx0kVtpfkQWc+TtYH/eY2jmTXUZWVx+kfn5qDI3Ojq9jRgfgM0tuICqTW78Vi2P4Qd5ektFkkAa9ERhhZRMzi0tbpQdyOQxEkflh3Upmuwm+im9Y4TdWNvVO3cM+DOCH1JNpEgh5OGo52/Tq/FUgzt750Ls1/QPzbmkgUYd9SmEknrS/dHm9XRm5D0RumQzW75CniuyZEx+Gn/C/+h+mHapBCXizUZEK9+y7er9MOmHTZ5Er9tb/bc6k7cQYXVzIGqLm8ENV1SYeSwxuTsPrvTsBGHqURBAnz3OllQD2yws5XmmIJ2L: ssh-rsa

