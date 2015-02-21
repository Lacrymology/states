{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set user = salt['pillar.get']('graylog2:server:user', 'graylog2') %}

graylog2:
  user:
    - present
    - name: {{ user }}
    - home: /var/run/{{ user }}
    - shell: /bin/false

/var/run/graylog2:
  file:
    - directory
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - makedirs: True
    - require:
      - user: graylog2
