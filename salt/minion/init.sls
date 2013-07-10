{#
 Install Salt Minion (client)
 #}

include:
  - apt
  - gsyslog
  - salt.minion.upgrade

{# it's mandatory to remove this file if the master is changed #}
salt_minion_master_key:
  module:
    - wait
    - name: file.remove
    - path: /etc/salt/pki/minion/minion_master.pub
    - watch:
      - file: salt-minion

{{ opts['cachedir'] }}/pkg_installed.pickle:
  file:
    - absent
