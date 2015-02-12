|deployment|\-es_cluster
~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`/elasticsearch/doc/index` cluster status.

Critical: number of nodes in cluster different from number of nodes
config in :ref:`pillar-elasticsearch-cluster-nodes`.

|deployment|\-es_http_port
~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`/elasticsearch/doc/index` HTTP port
``9200``/:ref:`glossary-TCP`.

|deployment|\-es_http
~~~~~~~~~~~~~~~~~~~~~

Check elasticsearch HTTP status port ``9200``/:ref:`glossary-TCP`,
expect return code `200 OK
<http://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success>`_.

|deployment|\-es_port_transport
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`/elasticsearch/doc/index` transport port
``9300``/:ref:`glossary-TCP`.
