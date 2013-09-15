{#-
 Unistalling GitLab
#}
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
    - name: initctl stop gitlab
    - user: root

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', web_dir, '/home/git', '/etc/init/gitlab.conf', '/etc/uwsgi/gitlab.ini', '/etc/logrotate.d/gitlab') %}
{{ file }}:
  file:
    - absent
    - require:
      - cmd: gitlab
{%- endfor %}
