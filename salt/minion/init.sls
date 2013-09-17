{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install Salt Minion (client)
 -#}

include:
  - rsyslog
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
        - service: rsyslog
      - watch:
        - module: salt_minion_master_key
    pkg:
      - pkgs:
        - salt-minion
        - lsb-release
{%- if grains['virtual'] != 'openvzve' %}
        - pciutils
        - dmidecode
{%- endif %}
      - require:
        - apt_repository: salt
        - cmd: apt_sources
        - pkg: apt_sources
  salt-common-modules-cp:
    file:
      - require:
        - pkg: salt-minion
