{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
include:
  - backup.client.local
  - backup.dumb
  - doc

test:
  cmd:
    - run
    - name: /usr/local/bin/backup-store `/usr/local/bin/create_dumb`
    - require:
      - file: /usr/local/bin/backup-store
      - file: /usr/local/bin/create_dumb
