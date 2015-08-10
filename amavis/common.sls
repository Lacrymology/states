{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

amavis:
  group:
    - present
    - system: True
  user:
    - present
    - system: True
    - gid_from_name: True
    - fullname: AMaViS system user
    - home: /var/lib/amavis
    - shell: /usr/sbin/nologin
    - require:
      - group: amavis
