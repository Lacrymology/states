{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
 Remove GitLab NRPE checks
-#}
/etc/nagios/nrpe.d/gitlab.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/gitlab-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-gitlab.cfg:
  file:
    - absent

