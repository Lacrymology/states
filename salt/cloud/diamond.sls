{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Diamond statistics for salt_cloud.
-#}

include:
  - diamond
  - salt.master.diamond

salt_cloud_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[salt-cloud]]
        exe = ^python \/usr\/bin\/salt-cloud
