{#-
Copyright (C) 2013 the Institute for Institutional Innovation by Data
Driven Design Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE  MASSACHUSETTS INSTITUTE OF
TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the names of the Institute for
Institutional Innovation by Data Driven Design Inc. shall not be used in
advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the
Institute for Institutional Innovation by Data Driven Design Inc.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'macros.jinja2' import manage_pid with context %}
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
      - user: tomcat
{%- call manage_pid('/var/run/tomcat6.pid', 'tomcat6', 'root', 'tomcat') %}
- pkg: tomcat
- user: tomcat
{%- endcall %}

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
