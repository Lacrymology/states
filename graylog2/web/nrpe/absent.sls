{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

 Remove graylog2 web Nagios NRPE checks
-#}
/etc/nagios/nrpe.d/graylog2-web.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/graylog2-nginx.cfg:
  file:
    - absent
