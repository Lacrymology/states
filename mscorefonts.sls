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
