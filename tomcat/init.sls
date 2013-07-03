{#
 Install Tomcat6
 #}

{#
 TODO: add Nagios NRPE state + absent state
 TODO: add Diamond integration + it's absent state if required
 #}

include:
  - apt

tomcat6:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  service:
    - running
    - enable: True
    - watch:
      - pkg: tomcat6
