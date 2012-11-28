include:
  - nrpe

mongodb:
  apt_repository:
     - present
     - address: http://downloads-distro.mongodb.org/repo/ubuntu-upstart
     - components:
       - 10gen
     - distribution: dist
     - key_id: 7F0CEB10
     - key_server: keyserver.ubuntu.com
  pkg:
     - latest
     - name: mongodb-10gen
     - require:
       - apt_repository: mongodb
  file:
    - managed
    - name: /etc/logrotate.d/mongodb
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/logrotate.jinja2
  service:
     - running
     - watch:
       - pkg: mongodb

/etc/nagios/nrpe.d/mongodb.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://mongodb/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/mongodb.cfg
