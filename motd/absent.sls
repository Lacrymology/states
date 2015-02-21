{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/motd.tail:
  file:
    - absent

/etc/motd:
  file:
    - absent
