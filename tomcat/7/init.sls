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
