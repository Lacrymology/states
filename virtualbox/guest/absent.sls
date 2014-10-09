virtualbox-guest:
  kmod:
    - absent
    - name: vboxsf
    - persist: True
  pkg:
    - purged
    - name: virtualbox-guest-dkms
    - require:
      - kmod: virtualbox-guest
