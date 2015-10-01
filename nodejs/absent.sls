{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

nodejs:
  pkg:
    - purged
  file:
    - name: /etc/apt/sources.list.d/nodejs.list
    - absent
