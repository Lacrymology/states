{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - apt

{#- dont include java, let user decide it #}
tomcat:
  pkg:
    - installed
    - name: tomcat6
    - require:
      - cmd: apt_sources
  user:
    - present
    - name: tomcat6
    - require:
      - pkg: tomcat
  service:
    - running
    - order: 50
    - name: tomcat6
    - require:
      - pkg: tomcat
      - file: add_catalina_env

add_catalina_env:
  file:
    - append
    - name: /etc/environment
    - text: |
        export CATALINA_HOME="/usr/share/tomcat6"
        export CATALINA_BASE="/var/lib/tomcat6"
