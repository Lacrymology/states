{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context %}
{{ upstart_absent('gitlab-sidekiq') }}
{{ upstart_absent('gitlab-git-http-server') }}
{{ upstart_absent('gitlab-unicorn') }}

gitlab:
  process:
    - wait_for_dead
    - name: ''
    - user: gitlab
    - require:
      - service: gitlab-sidekiq
      - service: gitlab-git-http-server
      - service: gitlab-unicorn
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
