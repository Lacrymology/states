include:
  - nrpe

salt-repository:
  file:
    - managed
    - template: jinja
    - name: /etc/apt/sources.list.d/saltstack-salt.list
    - user: root
    - group: root
    - mode: 600
    - source: salt://salt/apt.jinja2

{#
 this is until 0.16 is out
 #}
salt-patch:
  file:
    - managed
    - name: /usr/share/pyshared/salt/states/git.py
    - source: salt://salt/git.py
    - user: root
    - group: root
    - mode: 644

salt-minion:
  file:
    - managed
    - template: jinja
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 600
    - source: salt://salt/config.jinja2
  pkg:
    - latest
    - watch:
      - file: salt-repository
  service:
    - running
    - watch:
      - file: salt-patch
      - pkg: salt-minion
      - file: salt-minion

/etc/nagios/nrpe.d/salt-minion.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://salt/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-minion.cfg
