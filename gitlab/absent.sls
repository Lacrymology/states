{#-
 Unistalling GitLab
#}

gitlab:
  user:
    - absent
    - name: git
  file:
    - absent
    - name: /home/git
  postgre_user:
    - absent
    - runas: postgres
  postgre_database:
    - absent
    - runas: postgres
  
/etc/uwsgi/gitlab.ini:
  file:
    - absent

/etc/nginx/conf.d/gitlab.conf:
  file:
    - absent
