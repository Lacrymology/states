{#
 # common stuff between carbon and graphite
 #}

include:
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
  virtualenv:
    - managed
    - name: /usr/local/graphite
    - require:
      - module: virtualenv

/var/lib/graphite:
  file:
    - directory
    - user: www-data
    - group: graphite
    - mode: 770
    - require:
      - user: web
      - user: graphite

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
