{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
