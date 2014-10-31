.. Copyright (c) 2013, Hung Nguyen Viet
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
.. Neither the name of Hung Nguyen Viet nor the names of its contributors may be used
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

.. include:: /doc/include/add_pillar.inc

- :doc:`/jenkins/doc/index` :doc:`/jenkins/doc/pillar`
- :doc:`/salt/cloud/doc/index` :doc:`/salt/cloud/doc/pillar`
- :doc:`/salt/master/doc/index` :doc:`/salt/master/doc/pillar`

Mandatory
---------

salt_ci:host_key
~~~~~~~~~~~~~~~~

Host key of CI host. This need to be filled after setup CI server.

salt_ci:agent_pubkey
~~~~~~~~~~~~~~~~~~~~

SSH public key of ci-agent, who in charge of copying test result files
to CI server.

salt_ci:agent_privkey
~~~~~~~~~~~~~~~~~~~~~

SSH private key of ci-agent.

Optional
--------

salt_ci:ssh_port
~~~~~~~~~~~~~~~~

SSH port to copy result files through

Default: ``22``

salt_ci:timeout
~~~~~~~~~~~~~~~

Time before salt considers running test suite took too long and exits with
non-zero status code.

Default: ``86400``
