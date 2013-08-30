{#-
 Unistalling GitLab
#}
{%- set version = '6-0' %}
{%- set root_dir = "/usr/local/gitlabhq-" + version + "-stable"  %}

gitlab:
  user:
    - absent
    - name: git
    - force: True
  
/etc/uwsgi/gitlab.ini:
  file:
    - absent

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', root_dir, '/home/git') %}
{{ file }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/gitlab.ini

{%- endfor %}
