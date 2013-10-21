:Copyrights: Copyright (c) 2013, Bruno Clermont

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
:Authors: - Bruno Clermont

Pillar
======

Mandatory
---------

Example::

  rabbitmq:
    cluster:
      master: node-1
      cookie: xxx
      nodes:
        node-1:
          private: 192.168.1.1
          public: 20.168.1.1
        node-2:
          private: 192.168.1.2
          public: 20.168.1.2
    vhosts:
      vhostname: vhostpassword
    monitor:
      user: monitor
      password: xxx
    management:
      user: admin
      password: xxx
    hostnames:
      - rmq.example.com

rabbitmq:cluster:master
~~~~~~~~~~~~~~~~~~~~~~~

Master node ID.

rabbitmq:cluster:cookie
~~~~~~~~~~~~~~~~~~~~~~~

Random string used as the Erlang cookie.

rabbitmq:cluster:nodes:{{ node id }}:private
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IP/Hostname in LAN of RabbitMQ node.

rabbitmq:cluster:nodes:{{ node id }}:public
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IP/Hostname reachable from Internet of RabbitMQ node.

rabbitmq:vhosts
~~~~~~~~~~~~~~~

Dict of {'vhostname': 'password'} of all RabbitMQ virtualhosts.

rabbitmq:monitor:user
~~~~~~~~~~~~~~~~~~~~~

Username used to perform monitoring check.

rabbitmq:monitor:password
~~~~~~~~~~~~~~~~~~~~~~~~~

Password used to perform monitoring check.

rabbitmq:management:user
~~~~~~~~~~~~~~~~~~~~~~~~

Username used to perform management trough Web UI.

rabbitmq:management:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password used to perform management trough Web UI.

rabbitmq:hostnames
~~~~~~~~~~~~~~~~~~

List of hostnames that RabbitMQ management console is reachable.

Optional
--------

Example::

  rabbitmq:
    ssl: example.com
  shinken_pollers:
    - 192.168.1.1
  destructive_absent: False

destructive_absent
~~~~~~~~~~~~~~~~~~

If True, RabbitMQ data saved on disk is purged
when rabbitmq.absent is executed.

Default: ``False`` by default of that pillar key.
