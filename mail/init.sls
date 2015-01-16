{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
/etc/mailname:
  file:
    - managed
    - source: salt://mail/mailname.jinja2
    - template: jinja

{%- set mailname = salt['pillar.get']('mail:mailname') %}
host_{{ mailname }}:
  host:
    - present
    - name: {{ mailname }}
    - ip: 127.0.0.1
