{#-
 Copy files archive if necessary.
 -#}

include:
  - rsync

{%- set archive_dir = salt['user.info']('root')['home'] + '/salt/archive' %}
salt_archive:
  file:
    - directory
    - name: {{ archive_dir }}
    - user: root
    - group: root
    - mode: 775
  cmd:
    - run
    - name: /bin/true
{#    - name: rsync -av --delete {{ pillar['salt_archive']['source'] }} {{ archive_dir }}/#}
    - require:
      - pkg: rsync
      - file: salt_archive
