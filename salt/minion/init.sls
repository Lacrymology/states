{#
 Install Salt Minion (client)
 #}

include:
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

extend:
  salt-minion:
    service:
      - require:
        - service: gsyslog
      - watch:
        - module: salt_minion_master_key
    pkg:
      - names:
        - salt-minion
        - lsb-release
{%- if grains['virtual'] != 'openvzve' %}
        - pciutils
        - dmidecode
{%- endif %}
      - require:
        - apt_repository: salt
        - cmd: apt_sources
        - pkg: debconf-utils
        - pkg: python-software-properties
  salt-common-modules-cp:
    file:
      - require:
        - pkg: salt-minion
