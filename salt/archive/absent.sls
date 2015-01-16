{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
salt_archive:
  user:
    - absent
    - require:
      - file: salt_archive
  group:
    - absent
    - require:
      - user: salt_archive
  file:
    - absent
    - name: /var/lib/salt_archive
