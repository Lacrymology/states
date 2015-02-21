{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

system_timezone:
  timezone:
    - system
    - name: {{ salt['pillar.get']('timezone', 'UTC') }}
