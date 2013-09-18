{#-
 Author: Nicolas Plessis nicolas@microsigns.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
jenkins:
  pkg:
    - purged

/etc/nginx/conf.d/jenkins.conf:
  file:
    - absent

