Usage
=====

Basic usage of salt-master.

You can check all list of minions by::

  salt-key -L

To allow one minion to connect to master, run::

  salt-key -a [minion id]

To allow all minions to connect to master, run::

  salt-key -A

To delete one minion to disconnect to master, run::

  salt-key -d [minion id]

To delete all minions to disconnect to master, run::

  salt-key -D

After add key, check minion can connect to master or not, run::

  salt -t 600 [minion id] test.ping
