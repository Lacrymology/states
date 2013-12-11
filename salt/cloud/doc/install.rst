Salt Cloud
==========

:Copyrights: Copyright (c) 2013, Quan Tong Anh

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
:Authors: - Quan Tong Anh

Salt cloud is a public cloud provisioning tool. Salt cloud is made to integrate
Salt into cloud providers in a clean way so that minions on public cloud
systems can be quickly and easily modeled and provisioned.

Pillar
------

The first thing you have to prepare is creating pillar. In this document, I will 
show you an example of pillar for AWS EC2::

  {%- set domain_name = 'robotinfra.com' %}

  salt:
    master: q-salt.{{ domain_name }}
    cloud:
      providers:
        my-ec2-southeast-private-ips:
          ssh_interface: private_ips
          id: foo
          key: 'bar'
          private_key: /srv/pillar/ssh.priv
          keyname: q-configs
          securitygroup: default
          location: ap-southeast-1
          availability_zone: ap-southeast-1b
          ssh_username: ubuntu
          iam_profile: 'q-cloud'
          provider: ec2
      profiles:
        ci-minion:
          provider: my-ec2-southeast-private-ips
          script: bootstrap_salt
          image: ami-f094c0a2
          size: Micro Instance

Some settings need to be noticed:

* providers:
  * keyname: is the name of the SSH private key
  * provider: must be `ec2`

* profiles:
  * image: must have prefix `ami-`
  * size: Micro Instance, High-CPU Medium Instance, ...

Installation
------------

After creating the pillar, you have to push it to the Pillar repo on the Salt master::

  $ git remote -v
  origin  git@git.robotinfra.com:bruno/doc-pillar.git (fetch)
  origin  git@git.robotinfra.com:bruno/doc-pillar.git (push)
  salt-pillars    git@54.251.87.190:~git/salt-pillars.git (fetch)
  salt-pillars    git@54.251.87.190:~git/salt-pillars.git (push)

  $ git push salt-pillars master:master

Make sure that it is updated, if not, run the following command::

  # cd /srv/pillar
  # git pull

It's time to install `salt-cloud`::

  salt q-configs state.sls salt.cloud -v

The profile can be realized now with a salt command::

  salt-cloud -p ci-minion q-ci

If everything is OK, you will see something like this::

  Dec 17 10:33:42 salt-cloud saltcloud.loaded.int.cloud.ec2: Created node q-ci
  Dec 17 10:33:42 salt-cloud saltcloud.loaded.int.cloud.ec2: Salt node data. Private_ip: 10.129.29.67
  Dec 17 10:34:04 salt-cloud saltcloud.utils: Using /srv/pillar/ssh.priv as the key_filename
  Dec 17 10:34:04 salt-cloud saltcloud.utils: Attempting to authenticate as ubuntu (try 1 of 15)
  Dec 17 10:34:08 salt-cloud saltcloud.utils: Logging into 10.129.29.67:22 as ubuntu
  Dec 17 10:34:08 salt-cloud saltcloud.utils: SSH connection to 10.129.29.67 successful

Once the instance has been created with salt-minion installed, connectivity to
it can be verified with Salt::

  # salt q-ci test.ping
  q-ci:
      True
