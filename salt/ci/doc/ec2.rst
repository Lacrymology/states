==========
Amazon EC2
==========

Pillars
-------

Here is minimal pillars data to starts with.

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

Salt server side pillar, value XXX will be replaced later::

  salt:
    master: 127.0.0.1
    cloud:
      providers:
        amazon_ec2:
          ssh_interface: private_ips
          id: XXX
          key: XXX
          private_key: /root/.ssh/id_rsa
          keyname: XXX
          securitygroup: XXX
          location: XXX
          availability_zone: XXX
          ssh_username: ubuntu
          provider: ec2
      profiles:
        ci-minion:
          provider: amazon_ec2
          script: bootstrap_salt
          image: XXX
          size: XXX

Preparation
-----------

Pick an Amazon EC2 region. Set it in pillar
``salt:cloud:providers:amazon_ec2:location``.

Pick an availability zone (AZ) in that region (the region code followed by a
letter) and set it to ``salt:cloud:providers:availability_zone:location``.

Create an Amazon IAM identity. Set ID to pillar
``salt:cloud:providers:amazon_ec2:id``.

Generate the IAM user secret key, set ``salt:cloud:providers:amazon_ec2:key``.

Apply a policy for that IAM user that restrict it to a single EC2 region,
replace XXX by choose region name::

  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "ec2:*",
        "Effect": "Allow",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "ec2:Region": "XXX"
          }
        }
      }
    ]
  }

Create a new security group for Salt CI server, set it's name to
``salt:cloud:providers:amazon_ec2:securitygroup``.

Create a key pair for minions that perform tests, set it's name to
``salt:cloud:providers:amazon_ec2:keyname``. Take the content of the private
key and put it into ``deployment_key:contents`` this way::

  deployment_key:
    type: rsa
    contents: |
        -----BEGIN RSA PRIVATE KEY-----
        {# followed by the content #}
        -----END RSA PRIVATE KEY-----

Choose a EC2 image in http://cloud-images.ubuntu.com/releases/precise/release/
in the region you choosed. Set the ``ami-XXX`` value to
``salt:cloud:profiles:ci-minion:image``.

Pick VM size in
https://github.com/saltstack/salt-cloud/blob/0.8.9/saltcloud/clouds/ec2.py#L99
such as ``Micro Instance`` and set it to
``salt:cloud:profiles:ci-minion:size``


External Git Repositories
-------------------------

Skip this step if you use git repository hosted on the CI server itself.

Grant access to the key pair you created to you're Git/Bitbucket repositories.
If you need the OpenSSH compatible public key value, do the following::

  chmod 400 $keyfile.pem
  ssh-keygen -y -f $keyfile.pem

