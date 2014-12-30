{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Diamond statistics for Salt API.
-#}
include:
  - diamond
  - nginx.diamond
  - rsyslog.diamond
  - salt.master.diamond

salt_api_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt-api]]
        cmdline = ^python \/usr\/bin\/salt\-api$
