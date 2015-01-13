{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}

{% for filename in ('/etc/default/elasticsearch', '/etc/elasticsearch', '/etc/cron.daily/elasticsearch-cleanup', '/etc/nginx/conf.d/elasticsearch.conf') %}
{{ filename }}:
  file:
    - absent
    - require:
      - service: elasticsearch
{% endfor %}

{% if grains['cpuarch'] == 'i686' %}
/usr/lib/jvm/java-7-openjdk:
  file:
    - absent
    - require:
      - pkg: elasticsearch
{% endif %}

elasticsearch:
  pkg:
    - purged
    - require:
      - service: elasticsearch
  service:
    - dead
    - enable: False

/etc/elasticsearch/nginx_basic_auth:
  file:
    - absent
    - require:
      - service: elasticsearch
