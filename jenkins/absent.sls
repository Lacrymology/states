jenkins:
  pkg:
    - purged

/etc/nginx/conf.d/jenkins.conf:
  file:
    - absent

