tomcat:
  pkg:
    - purged
    - name: tomcat6-common
    - require:
      - service: tomcat
  service:
    - dead
    - name: tomcat6
  file:
    - absent
    - name: /etc/default/tomcat6
    - require:
      - pkg: tomcat

/etc/tomcat6:
  file:
    - absent
    - require:
      - pkg: tomcat

rm_catalina_env:
  cmd:
    - run
    - name: sed -i '\:tomcat6:d' /etc/environment
