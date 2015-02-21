{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

tomcat7:
  pkg:
    - purged
    - name: tomcat7-common
    - require:
      - service: tomcat7
  service:
    - dead
    - name: tomcat7
  file:
    - absent
    - name: /etc/default/tomcat7
    - require:
      - pkg: tomcat7
  cmd:
    - run
    - name: sed -i '\:tomcat7:d' /etc/environment

/etc/tomcat7:
  file:
    - absent
    - require:
      - pkg: tomcat7

/var/lib/tomcat7:
  file:
    - absent
    - require:
      - pkg: tomcat7
