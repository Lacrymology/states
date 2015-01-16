{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - diamond
  - rsyslog.diamond

shinken_receiver_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[shinken-receiver]]
        cmdline = ^\/usr\/local\/shinken\/bin\/python \/usr\/local\/shinken\/bin\/shinken-receiver
