{#
 Undo screen state
 #}
/etc/screenrc:
  file:
    - absent

screen:
  pkg:
    - purged
