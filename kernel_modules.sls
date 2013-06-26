{#
 cleanup Linux kernel modules
 #}
{% if grains['virtual'] != 'openvzve' %}
useless_kmod:
  kmod:
    - absent
    - names:
      - lp
      - floppy
      - ppdev
      - serio_raw
      - parport_pc
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
      - jfs
      - isofs
      - xfs
      - btrfs
{% if 'availabilityZone' in grains %}
      - acpiphp
      - ext2
{% endif %}

dependencies_kmod:
  kmod:
    - absent
    - names:
      - parport
      - fat
      - libcrc32c
      - zlib_deflate
    - require:
      - kmod: useless_kmod
{% endif %}
