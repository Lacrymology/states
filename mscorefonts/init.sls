{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
Installing MS core fonts
-#}
mscorefonts:
  pkg:
    - installed
    - name: ttf-mscorefonts-installer
    - require:
      - debconf: set_mscorefonts

set_mscorefonts:
  debconf:
    - set
    - name: ttf-mscorefonts-installer
    - data:
        msttcorefonts/accepted-mscorefonts-eula: {'type': 'boolean', 'value': True}
