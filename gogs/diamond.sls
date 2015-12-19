{#- Usage of this is governed by a license that can be found in doc/license.rst #}
{%- set version = '0.8.10' -%}

include:
  - diamond
  - git.server.diamond
  - nginx.diamond
  - postgresql.server.diamond

gogs_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[gogs]]
        cmdline = ^/usr/local/gogs/{{ version }}/gogs/gogs
