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
      - jfs
      - isofs
{% if 'availabilityZone' in grains %}
      - acpiphp
      - ext2
{% endif %}

fat:
  kmod:
    - absent
    - require:
      - kmod: useless_kmod
{% endif %}
