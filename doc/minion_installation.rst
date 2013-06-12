Salt-Minion Installation
========================

By default, salt minion take the hostname of the host as the minion ID.
First set it, as root, you might need to run ``sudo bash`` first::

  sudo bash
  hostname mysuperminion

Then install salt::

    wget -O - https://raw.github.com/saltstack/salt-bootstrap/stable/bootstrap-salt.sh | sudo sh
    stop salt-minion
    rm -f /var/log/salt/minion

Configure your minion to connect to your master, replace 1.2.3.4 with your
Salt Master IP::

  echo 'master: 1.2.3.4' > /etc/salt/minion
  echo 'log_level: debug' >> /etc/salt/minion
  start salt-minion

Then on salt master::

  salt-key -a mysuperminion

Test your minion connectivity::

  salt mysuperminion test.ping

Before running state.highstate, synchronize it::

  salt mysuperminion saltutil.sync_all

