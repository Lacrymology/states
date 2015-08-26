{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

jenkins:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: jenkins
  user:
    - absent
    - require:
      - pkg: jenkins

/etc/nginx/conf.d/jenkins.conf:
  file:
    - absent

/etc/cron.daily/jenkins_delete_old_workspaces:
  file:
    - absent

/etc/cron.daily/jenkins_delete_old_jobs:
  file:
    - absent

/etc/jenkins:
  file:
    - absent
