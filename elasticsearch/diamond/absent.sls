{#-
Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

 Turn off Diamond statistics for Elasticsearch
-#}
/etc/diamond/collectors/ElasticSearchCollector.conf:
  file:
    - absent
