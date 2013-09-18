{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
 Unistalling GitLab
-#}
{%- set version = '6-0' %}
{%- set web_dir = "/usr/local/gitlabhq-" + version + "-stable"  %}

gitlab:
  user:
    - absent
    - force: True
    - require:
      - cmd: gitlab
  group:
    - absent
    - require:
      - user: gitlab
  cmd:
    - run
    - name: kill -9 $(ps -ef | grep sidekiq | grep -v grep | awk  '{print $2}')
    - user: root
    - onlyif: ps -ef | grep sidekiq | grep -v grep

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', web_dir, '/home/git', '/etc/init/gitlab.conf', '/etc/uwsgi/gitlab.ini', '/etc/logrotate.d/gitlab') %}
{{ file }}:
  file:
    - absent
    - require:
      - cmd: gitlab
{%- endfor %}
