{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Diamond statistics for Jenkins.
-#}
include:
  - cron.diamond
  - diamond
  - nginx.diamond

jenkins_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[jenkins]]
        cmdline = \/usr\/bin\/daemon --name=jenkins,\/usr\/bin\/java -jar \/usr\/share\/jenkins\/jenkins.war
