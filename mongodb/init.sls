{#
 Install a MongoDB NoSQL server.

 If one day MongoDB support SSL in free distribution, do this:
 http://docs.mongodb.org/manual/tutorial/configure-ssl/
 #}
include:
  - logrotate
  - apt

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
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/logrotate.d/mongodb
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/logrotate.jinja2
    - require:
      - pkg: logrotate
  service:
    - running
    - enable: True
    - watch:
      - pkg: mongodb
