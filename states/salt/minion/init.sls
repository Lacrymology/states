{#
 Install Salt Minion (client)
 #}
include:
  - nrpe
  - diamond

salt-minion:
  apt_repository:
    - ubuntu_ppa
    - user: saltstack
    - name: salt
    - key_id: 0E27C0A6
  file:
    - managed
    - template: jinja
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/minion/config.jinja2
  pkg:
    - installed
    {# ^- use to be latest, but 0.12.x is just broken #}
    - names:
      - python-openssl
      - salt-minion
  service:
    - running
    - enable: True
    - watch:
      - pkg: salt-minion
      - file: salt-minion

salt_minion_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt.minion]]
        cmdline = ^python \/usr\/bin\/salt\-minion$

/etc/nagios/nrpe.d/salt-minion.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://salt/minion/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-minion.cfg

