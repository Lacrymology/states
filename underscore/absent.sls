{#-
Removing Underscore
#}
# {{ pillar['message_do_not_modify'] }}
libjs-underscore:
  pkgrepo:
    - absent
    - ppa: chris-lea/libjs-underscore
  pkg:
    - purged
