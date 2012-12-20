include:
  - nrpe

{#
 # echo 'deb http://ppa.launchpad.net/saltstack/salt/ubuntu precise main' > /etc/apt/sources.list.d/saltstack-salt-precise.list
 # apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E27C0A6
 # apt-get update
 # apt-get install salt-minion
 #}

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
    - source: salt://salt/config.jinja2
  pkg:
    - latest
  service:
    - running
    - enable: True
    - watch:
      - file: salt-patch-git
      - file: salt-patch-djangomod
      - pkg: salt-minion
      - file: salt-minion

/etc/nagios/nrpe.d/salt-minion.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://salt/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-minion.cfg

