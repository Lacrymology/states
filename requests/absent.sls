{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

requests:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/requests
