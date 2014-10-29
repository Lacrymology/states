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

Amazon EC2
==========

Here is minimal :doc:`pillar` data to starts with.

First setup APT to use Amazon S3 internal mirrors::

  apt:
    sources: |
      deb http://security.ubuntu.com/ubuntu {{ grains['oscodename'] }}-security {{ all_suites }}
      deb http://{{ grains['region'] }}.ec2.archive.ubuntu.com/ubuntu/ {{ grains['oscodename'] }} {{ all_suites }}
      deb http://{{ grains['region'] }}.ec2.archive.ubuntu.com/ubuntu/ {{ grains['oscodename'] }}-updates {{ all_suites }}
      deb http://{{ grains['region'] }}.ec2.archive.ubuntu.com/ubuntu/ {{ grains['oscodename'] }}-backports {{ all_suites }}

Make CI server act as an NTP servers for all tested minions::

  ntp:
    server: True
    servers:
  {% for i in range(0, 4) %}
      - {{ i }}.amazon.pool.ntp.org
  {% endfor %}


External Git Repositories
-------------------------

Skip this step if you use git repository hosted on the CI server itself.

Grant access to the key pair you created to you're Git/Bitbucket repositories.
If you need the :doc:`/ssh/doc/index` compatible public key value, do the
following::

  chmod 400 $keyfile.pem
  ssh-keygen -y -f $keyfile.pem

Server Installation
-------------------

Create a security only for the C.I. server. Allow in :doc:`/ssh/doc/index`,
HTTP and HTTPs (if you turned on :doc:`/ssl/doc/index`).
Allow all TCP, UDP and ICMP traffic from security group
``salt_cloud:providers:amazon_ec2:securitygroup`` in.

Create a VM in the same region and availabilty zone as in
``salt_cloud:providers:availability_zone:location``. You don't have to use the
same keypair previously created.

A **t1.micro** instance is not enough for you, as salt-cloud leak memory you
you should take a **m1.medium**.

