salt-fire-event:
  group:
    - absent

/etc/sudoers.d/salt_fire_event:
  file:
    - absent
    - require:
      - group: salt-fire-event

/usr/local/bin/salt_fire_event.py:
  file:
    - absent
