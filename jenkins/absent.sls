{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
jenkins:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: jenkins

/etc/nginx/conf.d/jenkins.conf:
  file:
    - absent

/etc/cron.daily/jenkins_delete_old_workspaces.py:
  file:
    - absent

/etc/cron.daily/jenkins_delete_old_workspaces:
  file:
    - absent
