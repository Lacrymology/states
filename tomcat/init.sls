{#
 Install Tomcat6
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
