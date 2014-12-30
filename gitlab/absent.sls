{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from "upstart/absent.sls" import upstart_absent with context %}
{{ upstart_absent('gitlab') }}

gitlab-uwsgi:
  file:
    - absent
    - name: /etc/uwsgi/gitlab.yml

extend:
  gitlab:
    process:
      - wait_for_dead
      - name: ''
      - user: gitlab
      - require:
        - file: gitlab-uwsgi
        - service: gitlab
    user:
      - absent
      - force: True
      - purge: True
      - require:
        - process: gitlab

/etc/nginx/conf.d/gitlab.conf:
  file:
    - absent

/var/log/gitlab:
  file:
    - absent

/var/lib/gitlab:
  file:
    - absent

/etc/logrotate.d/gitlab:
  file:
    - absent
