{#-
 Copy files archive if necessary.
 -#}

include:
  - rsync

{%- set archive_dir = salt['user.info']('root')['home'] + '/salt/archive' %}
{{ archive_dir }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 775
  cmd:
    - run
    - name: rsync -av --delete {{ pillar['salt_archive']['source'] }} {{ archive_dir }}/
    - require:
      - pkg: rsync
      - file: {{ archive_dir }}
