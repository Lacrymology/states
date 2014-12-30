{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Common stuff between carbon and graphite.
-#}

include:
  - local
  - virtualenv
  - web

graphite:
  user:
    - present
    - shell: /bin/false
    - home: /usr/local/graphite
    - password: "*"
    - enforce_password: True
    - gid_from_name: True
    - groups:
      - www-data
    - require:
      - user: web
      - file: /usr/local
  virtualenv:
    - managed
    - name: /usr/local/graphite
    - require:
      - module: virtualenv
      - user: graphite

/var/lib/graphite:
  file:
    - directory
    - user: www-data
    - group: graphite
    - mode: 770
    - require:
      - user: web
      - user: graphite

/var/lib/graphite/whisper:
  file:
    - directory
    - user: www-data
    - group: graphite
    - mode: 770
    - require:
      - user: web
      - user: graphite
      - file: /var/lib/graphite

{%- set instances_count = salt['pillar.get']('carbon:cache_daemons') %}
{% for instance in range(instances_count) %}
/var/lib/graphite/whisper/{{ instance }}:
  file:
    - directory
    - user: www-data
    - group: graphite
    - mode: 770
    - require:
      - user: web
      - user: graphite
      - file: /var/lib/graphite/whisper
{%- endfor %}

/etc/graphite:
  file:
    - directory
    - user: graphite
    - group: graphite
    - mode: 770
    - require:
      - user: graphite

/var/log/graphite:
  file:
    - directory
    - user: root
    - group: root
    - mode: 555
    - makedirs: True
