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
    - watch:
      - pkg: tomcat
      - file: add_catalina_env
      - file: /usr/share/tomcat6/shared
      - file: /usr/share/tomcat6/server

add_catalina_env:
  file:
    - append
    - name: /etc/environment
    - text: |
        export CATALINA_HOME="/usr/share/tomcat6"
        export CATALINA_BASE="/var/lib/tomcat6"

{# until a better fix... #}
/usr/share/tomcat6/shared:
  file:
    - symlink
    - target: /var/lib/tomcat6/shared
    - require:
      - pkg: tomcat

/usr/share/tomcat6/server:
  file:
    - symlink
    - target: /var/lib/tomcat6/server
    - require:
      - pkg: tomcat
