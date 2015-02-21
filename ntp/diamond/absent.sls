{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

diamond_ntp:
  file:
    - absent
    - name: /etc/diamond/collectors/NtpdCollector.conf
