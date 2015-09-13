{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

mscorefonts:
  pkg:
    - purged
    - name: ttf-mscorefonts-installer

{#- exist if failed to download fonts #}
/var/lib/update-notifier:
  file:
    - absent
