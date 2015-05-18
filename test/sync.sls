{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-
Copy files archive if necessary.
-#}

{%- set archive_dir = salt['user.info']('root')['home'] + '/salt/archive' %}
salt_archive:
  pkg:
    - installed
    - name: rsync
  file:
    - directory
    - name: {{ archive_dir }}
    - makedirs: True
    - user: root
    - group: root
    - mode: 775
  cmd:
    - run
{% set source = salt['pillar.get']('salt_archive:source', False) %}
{%- if source %}
    - name: rsync -av --delete --exclude ".*" {{ source }} {{ archive_dir }}/
{%- else %}
    - name: echo no pillar defined for archive source
{%- endif %}
    - require:
      - pkg: salt_archive
      - file: salt_archive
