{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond

s3cmd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[s3cmd]]
        cmdline = ^\/usr\/bin\/python \/usr\/local\/local\/bin\/s3cmd
