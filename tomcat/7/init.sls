{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'macros.jinja2' import manage_pid with context %}
include:
  - apt

{#- dont include java, let user decide it #}
tomcat:
  pkg:
    - installed
    - name: tomcat7
    - require:
      - cmd: apt_sources
  user:
    - present
    - name: tomcat7
    - require:
      - pkg: tomcat
  service:
    - running
    - name: tomcat7
    - order: 50
    - watch:
      - user: tomcat
    - require:
      - pkg: tomcat
      - file: add_catalina_env
      - file: tomcat
  file:
    - managed
    - source: salt://tomcat/7/config.jinja2
    - template: jinja
    - name: /etc/default/tomcat7
    - mode: 440
    - require:
      - pkg: tomcat

{%- call manage_pid('/var/run/tomcat7.pid', 'tomcat7', 'root', 'tomcat') %}
- pkg: tomcat
- user: tomcat
{%- endcall %}

add_catalina_env:
  file:
    - append
    - name: /etc/environment
    - text: |
        export CATALINA_HOME="/usr/share/tomcat7"
        export CATALINA_BASE="/var/lib/tomcat7"
