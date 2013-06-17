{#
 Install Salt Minion (client)
 #}

include:
  - apt
  - gsyslog
  - salt

{# it's mandatory to remove this file if the master is changed #}
salt_minion_master_key:
  module:
    - wait
    - name: file.remove
    - path: /etc/salt/pki/minion/minion_master.pub
    - watch:
      - file: salt-minion

salt-minion:
  file:
    - managed
    - template: jinja
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/minion/config.jinja2
    - require:
      - pkg: salt-minion
  pkg:
    - installed
    - names:
      - salt-minion
      - lsb-release
{% if grains['virtual'] != 'openvzve' %}
      - pciutils
      - dmidecode
{% endif %}
    - require:
      - apt_repository: salt
      - cmd: apt_sources
      - pkg: debconf-utils
      - pkg: python-software-properties
  service:
    - running
    - enable: True
    - require:
      - service: gsyslog
    - watch:
      - pkg: salt-minion
      - file: salt-minion
      - module: salt_minion_master_key

{{ opts['cachedir'] }}/pkg_installed.pickle:
  file:
    - absent
