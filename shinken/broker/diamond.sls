{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Diamond statistics for Shinken Broker.
-#}
include:
  - diamond
  - nginx.diamond
  - rsyslog.diamond

shinken_broker_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[shinken-broker]]
        cmdline = ^\/usr\/local\/shinken\/bin\/python \/usr\/local\/shinken\/bin\/shinken-broker
