{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
tomcat6:
  pkg:
    - purged
    - name: tomcat6-common
    - require:
      - service: tomcat6
  service:
    - dead
    - name: tomcat6
  file:
    - absent
    - name: /etc/default/tomcat6
    - require:
      - pkg: tomcat6
  cmd:
    - run
    - name: sed -i '\:tomcat6:d' /etc/environment

/etc/tomcat6:
  file:
    - absent
    - require:
      - pkg: tomcat6

