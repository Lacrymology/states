{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
salt_archive:
  user:
    - present
    - fullname: Salt Archive
    - shell: /bin/false
    - home: /var/lib/salt_archive
    - createhome: False
  file:
    - directory
    - name: /var/lib/salt_archive
    - user: root
    - group: salt_archive
    - mode: 755
    - require:
      - user: salt_archive
