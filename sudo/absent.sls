{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

sudo:
  pkg:
    - purged
    - env:
        'SUDO_FORCE_REMOVE': 'yes'
  file:
    - absent
    - name: /etc/sudoers.d
    - require:
      - pkg: sudo
