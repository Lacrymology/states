{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - diamond
  - nginx.diamond
  - nodejs.diamond
  - postgresql.server.diamond
  - rsyslog.diamond

etherpad_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[etherpad]]
        cmdline = ^node node_modules\/ep_etherpad\-lite\/node\/server\.js$
