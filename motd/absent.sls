{#
 Undo motd state
#}
/etc/motd.tail:
  file:
    - absent
