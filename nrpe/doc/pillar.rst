.. Copyright (c) 2009, Luan Vo Ngoc
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
.. Neither the name of Luan Vo Ngoc nor the names of its contributors may be used
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

Pillar
======

Mandatory
---------

Example::

  nrpe:
    nsca:
      servers:
        - 192.168.1.1
        - 192.168.1.2
      password: Dba1dwjx
      
  shinken_pollers:
    - 192.168.1.1
    - 129.168.1.2

nrpe:nsca:servers
~~~~~~~~~~~~~~~~~

IPs address of each node on :doc:`/shinken/doc/index`
`receiver <http://www.shinken-monitoring.org/wiki/nsca_daemon_module>`__ server.

nrpe:nsca:password
~~~~~~~~~~~~~~~~~~

Password use to submit passive check to NSCA daemon.

shinken_pollers
~~~~~~~~~~~~~~~

As documented in :doc:`/doc/pillar`, IPs address of system load balancing
:doc:`/shinken/doc/index`.

Optional
--------

Example::

  nrpe:
    max_proc: 500

nrpe:max_proc
~~~~~~~~~~~~~

How many process can run on the system before it raise a warning.

Default: ``150``
