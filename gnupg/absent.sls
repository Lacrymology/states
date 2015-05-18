{%- from 'ssh/common.sls' import root_home with context %}

gnupg:
  pkg:
    - purged
    - pkgs:
      {# - gnupg #} {#- can't remove, apt requires it #}
      - python-gnupg
  file:
    - absent
    - name: {{ root_home() }}/.gnupg
