{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

 Remove Nagios NRPE checks for elasticsearch
 -#}
/etc/nagios/nrpe.d/elasticsearch.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/elasticsearch-nginx.cfg:
  file:
    - absent

/usr/local/bin/check_elasticsearch_cluster.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
  file:
    - absent
