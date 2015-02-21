{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/mailname:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: {{ salt['pillar.get']('mail:mailname') }}
    - template: jinja

{%- set mailname = salt['pillar.get']('mail:mailname') %}
host_{{ mailname }}:
  host:
    - present
    - name: {{ mailname }}
    - ip: 127.0.0.1
