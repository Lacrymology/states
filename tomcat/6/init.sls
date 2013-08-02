include:
  - apt

{#- dont include java, let user decide it #}
tomcat:
  pkg:
    - installed
    - name: tomcat6
    - require:
     - cmd: apt_sources
  service:
    - running
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
