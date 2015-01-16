{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - cron.diamond
  - diamond
  - diamond.nrpe
  - rsyslog.diamond

nrpe_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[nrpe]]
        exe = ^\/usr\/sbin\/nrpe$
        cmdline = ^\/usr\/lib\/nagios\/plugins\/check_
        [[nsca_passive]]
        cmdline = ^nsca_passive$
