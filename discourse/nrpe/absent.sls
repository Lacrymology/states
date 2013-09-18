{#-
 Author: Lam Dang Tung lamdt@familug.org
 Maintainer: Lam Dang Tung lamdt@familug.org
 
 Remove GitLab NRPE checks
-#}
/etc/nagios/nrpe.d/gitlab.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/discourse-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-discourse.cfg:
  file:
    - absent


