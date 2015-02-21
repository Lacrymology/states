{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/screenrc:
  file:
    - absent

screen:
  pkg:
    - purged
