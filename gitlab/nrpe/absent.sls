{#
 Remove GitLab NRPE checks
#}
/etc/nagios/nrpe.d/gitlab.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/gitlab-nginx.cfg:
  file:
    - absent
