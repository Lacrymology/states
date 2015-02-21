{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
