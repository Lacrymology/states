Amazon EC2
==========


Salt server side pillar, value XXX will be replaced later::

  salt_cloud:
    master: ci.example.com #  address of salt_cloud server
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

Pick an Amazon EC2 region. Set it in pillar
``salt_cloud:providers:amazon_ec2:location``.

Pick an availability zone (AZ) in that region (the region code followed by a
letter) and set it to ``salt_cloud:providers:availability_zone:location``.

Create an Amazon IAM identity. Set ID to pillar
``salt_cloud:providers:amazon_ec2:id``.

Generate the IAM user secret key, set ``salt_cloud:providers:amazon_ec2:key``.

Create a new security group for Salt CI server, set it's name to
``salt_cloud:providers:amazon_ec2:securitygroup``.

Create a key pair for minions that perform tests, set it's name to
``salt_cloud:providers:amazon_ec2:keyname``. Take the content of the private
key and put it into ``deployment_key:contents`` this way::

  deployment_key:
    type: rsa
    contents: |
        -----BEGIN RSA PRIVATE KEY-----
        {# followed by the content #}
        -----END RSA PRIVATE KEY-----

Choose a EC2 image in
`Ubuntu releases <http://cloud-images.ubuntu.com/releases/precise/release/>`__
in the region you choosed. Set the ``ami-XXX`` value to
``salt_cloud:profiles:ci-minion:image``.

Pick VM size in
`salt cloud ec2 python module <https://github.com/saltstack/salt-cloud/blob/0.8.9/saltcloud/clouds/ec2.py#L99>`__
such as ``Micro Instance`` and set it to
``salt_cloud:profiles:ci-minion:size``

Limit Access
------------

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
