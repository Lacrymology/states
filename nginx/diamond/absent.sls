{#
 Remove Diamond statistics for Nginx
#}
/etc/diamond/collectors/NginxCollector.conf:
  file:
    - absent
