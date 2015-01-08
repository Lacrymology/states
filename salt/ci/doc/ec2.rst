Amazon EC2
==========

Here is minimal :doc:`pillar` data to starts with.

First setup :doc:`/apt/doc/index` to use Amazon S3 internal mirrors::

  apt:
    sources: |
      deb http://security.ubuntu.com/ubuntu {{ grains['oscodename'] }}-security {{ all_suites }}
      deb http://{{ grains['region'] }}.ec2.archive.ubuntu.com/ubuntu/ {{ grains['oscodename'] }} {{ all_suites }}
      deb http://{{ grains['region'] }}.ec2.archive.ubuntu.com/ubuntu/ {{ grains['oscodename'] }}-updates {{ all_suites }}
      deb http://{{ grains['region'] }}.ec2.archive.ubuntu.com/ubuntu/ {{ grains['oscodename'] }}-backports {{ all_suites }}

Make CI server act as an :doc:`/ntp/doc/index` servers for all tested minions::

  ntp:
    server: True
    servers:
  {% for i in range(0, 4) %}
      - {{ i }}.amazon.pool.ntp.org
  {% endfor %}


External Git Repositories
-------------------------

Skip this step if you use :doc:`/git/doc/index` repository hosted on the CI
server itself.

Grant access to the key pair you created to you're Git/Bitbucket repositories.
If you need the :doc:`/ssh/doc/index` compatible public key value, do the
following::

  chmod 400 $keyfile.pem
  ssh-keygen -y -f $keyfile.pem

Server Installation
-------------------

Create a security only for the C.I. server. Allow in :doc:`/ssh/doc/index`,
:ref:`glossary-HTTP` and :ref:`glossary-HTTPS` (if you turned on :doc:`/ssl/doc/index`).
Allow all :ref:`glossary-TCP`, :ref:`glossary-UDP` and ICMP traffic from security group
``salt_cloud:providers:amazon_ec2:securitygroup`` in.

Create a VM in the same region and availabilty zone as in
``salt_cloud:providers:availability_zone:location``. You don't have to use the
same keypair previously created.

A **t1.micro** instance is not enough for you, as salt-cloud leak memory you
you should take a **m1.medium**.

