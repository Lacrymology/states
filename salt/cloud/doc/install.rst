.. TODO: I DON'T THIS IS SALT CLOUD SPECIFIC

Some settings need to be noticed:

* providers:
  * keyname: is the name of the :doc:`/ssh/doc/index` private key
  * provider: must be ``ec2``

* profiles:
  * image: must have prefix ``ami-``
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

It's time to install ``salt-cloud``::

  salt myminion state.sls salt.cloud -v

The profile can be realized now with a salt command::

  salt-cloud -p ci-minion myminion

If everything is OK, you will see something like this::

  Dec 17 10:33:42 salt-cloud saltcloud.loaded.int.cloud.ec2: Created node myminion
  Dec 17 10:33:42 salt-cloud saltcloud.loaded.int.cloud.ec2: Salt node data. Private_ip: 10.129.29.67
  Dec 17 10:34:04 salt-cloud saltcloud.utils: Using /srv/pillar/ssh.priv as the key_filename
  Dec 17 10:34:04 salt-cloud saltcloud.utils: Attempting to authenticate as ubuntu (try 1 of 15)
  Dec 17 10:34:08 salt-cloud saltcloud.utils: Logging into 10.129.29.67:22 as ubuntu
  Dec 17 10:34:08 salt-cloud saltcloud.utils: SSH connection to 10.129.29.67 successful

Once the instance has been created with salt-minion installed, connectivity to
it can be verified with Salt::

  # salt myminion test.ping
  myminion:
      True
