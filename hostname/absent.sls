{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

hostname:
  file:
    - absent
    - name: /etc/hostname

/etc/hosts:
  file:
    - absent
