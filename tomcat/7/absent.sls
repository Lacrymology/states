tomcat:
  pkg:
    - purged
    - name: tomcat7-common
    - require:
      - service: tomcat
  service:
    - dead
    - name: tomcat7
  file:
    - absent
    - name: /etc/default/tomcat7
    - require:
      - pkg: tomcat

/etc/tomcat7:
  file:
    - absent
    - require:
      - pkg: tomcat

rm_catalina_env:
  cmd:
    - run
    - name: sed -i '\:tomcat7:d' /etc/environment
