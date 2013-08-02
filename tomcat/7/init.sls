tomcat:
  pkg:
    - installed
    - name: tomcat7
  service:
    - running
    - name: tomcat7
    - require:
      - pkg: tomcat
      - file: add_catalina_env
      - pkg: libpostgresql-jdbc-java
      - file: tomcat
  file:
    - managed
    - source: salt://tomcat7/config.jinja2
    - name: /etc/default/tomcat7
    - require:
      - pkg: tomcat

add_catalina_env:
  file:
    - append
    - name: /etc/environment
    - text: |
        export CATALINA_HOME="/usr/share/tomcat7"
        export CATALINA_BASE="/var/lib/tomcat7"

libpostgresql-jdbc-java:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

/var/lib/tomcat7/server/postgresql.jar:
  file:
    - symlink
    - target: /usr/share/java/postgresql.jar
    - require:
      - pkg: libpostgresql-jdbc-java
    - require_in:
      - service: tomcat
