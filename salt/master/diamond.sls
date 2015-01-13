{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Diamond statistics for Salt Master.
-#}
include:
  - diamond
  - rsyslog.diamond

salt_master_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt-master]]
        cmdline = ^\/usr\/bin\/python \/usr\/bin\/salt\-master$
