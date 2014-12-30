{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
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

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/nagios/elasticsearch-requirements.txt:
  file:
    - absent

