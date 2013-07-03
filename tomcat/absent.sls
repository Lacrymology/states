{#
Remove Tomcat6
#}
tomcat6:
  pkg:
    - purged
    - require:
      - service: tomcat6
  service:
    - dead
