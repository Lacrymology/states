{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
