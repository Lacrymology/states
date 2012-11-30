{% if grains['virtual'] != 'openvzve' %}
useless_kmod:
  kmod:
    - absent
    - names:
      - lp
      - floppy
      - parport_pc
      - parport
      - psmouse
      - reiserfs
      - ufs
      - qnx4
      - hfsplus
      - hfs
      - minix
      - ntfs
      - vfat
      - msdos
      - fat
      - jfs
      - isofs
{% if 'availabilityZone' in grains %}
      - acpiphp
      - ext2
{% endif %}
{% endif %}
