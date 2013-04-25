{#
 Remove Nagios NRPE checks for elasticsearch
 #}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/elasticsearch.cfg
        - file: /etc/nagios/nrpe.d/elasticsearch-nginx.cfg
{% endif %}

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
