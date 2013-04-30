{#
 Undo virtualenv backup state
 #}
/usr/local/bin/backup-pip:
  file:
    - absent
