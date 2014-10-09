virtualbox-guest:
  pkg:
    - purged
    - name: virtualbox-guest-dkms
    - require:
      - kmod: virtualbox-guest
