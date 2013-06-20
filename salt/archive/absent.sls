salt_archive:
  user:
    - absent
    - require:
      - file: salt_archive
  file:
    - absent
    - name: /var/lib/salt_archive
