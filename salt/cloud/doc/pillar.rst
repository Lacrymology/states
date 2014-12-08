.. Copyright (c) 2013, Lam Dang Tung
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
.. Neither the name of Lam Dang Tung nor the names of its contributors may be used
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

- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/salt/minion/doc/index` :doc:`/salt/minion/doc/pillar`

Mandatory
---------

Example::

  salt_cloud:
    master: 1.2.3.4
    profiles:
      <profile_name>:
        <attribute_name>: <value>
    providers:
      <provider_name>:
        <attribute_name>: <value>

salt_cloud:master
~~~~~~~~~~~~~~~~~

Address of salt-master for all salt-cloud managed VMs.

Optional
--------

salt_cloud:profiles
~~~~~~~~~~~~~~~~~~~

Dict of {profile_name: {attribute_name: value}}, each dict contains data
to configure a salt-cloud profile.

Consult http://docs.saltstack.com/en/latest/topics/cloud/index.html#salt-cloud
for more information.

Default: ``{}``.

salt_cloud:providers
~~~~~~~~~~~~~~~~~~~~

Dict of {provider_name: {attribute_name: value}}, each dict contains data
to configure a salt-cloud provider.

Consult http://docs.saltstack.com/en/latest/topics/cloud/index.html#salt-cloud
for more information.

Default: ``{}``.
