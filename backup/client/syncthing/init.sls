{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
include:
  - syncthing
  - backup.client.local

extend:
  /usr/local/bin/backup-store:
    file:
      - source: salt://backup/client/syncthing/backup-store.jinja2
      - require:
        - user: syncthing
