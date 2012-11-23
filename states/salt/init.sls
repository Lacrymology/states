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
    - refresh: True
    - watch:
      - file: salt-repository
  service:
    - running
    - watch:
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
