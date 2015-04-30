{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('elasticsearch') }}

/etc/nagios/nrpe.d/elasticsearch-nginx.cfg:
  file:
    - absent

/usr/local/bin/check_elasticsearch_cluster.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_elasticsearch_cluster.py:
  file:
    - absent

pyelasticsearch:
  file:
    - absent
    - name: /usr/local/nagios/salt-elasticsearch-requirements.txt

{{ opts['cachedir'] }}/pip/elasticsearch:
  file:
    - absent
