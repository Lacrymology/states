{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>
-#}
{%- set ssl = salt['pillar.get']('elasticsearch:ssl', False) %}
include:
  - elasticsearch
  - elasticsearch.backup
  - elasticsearch.backup.nrpe
  - elasticsearch.diamond
  - elasticsearch.nrpe
{% if ssl %}
  - nginx.diamond
  - nginx.nrpe
  - ssl.nrpe
{% endif %}

elasticsearch_cluster:
  monitoring:
    - run_check
    - wait: 60
    - accepted_failure: 1 nodes in cluster (outside range 2:2)
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.nrpe

elasticsearch_test_create_sample_data:
  pkg:
    - installed
    - name: curl
  cmd:
    - run
    - name: 'curl -XPUT ''http://localhost:9200/twitter/tweet/1'' -d ''{"user" : "kimchy", "post_date" : "2009-11-15T14:12:12", "message" : "trying out Elasticsearch"}'''
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.backup
      - pkg: elasticsearch_test_create_sample_data

test:
  cmd:
    - run
    - name: /etc/cron.daily/backup-elasticsearch
    - require:
      - sls: elasticsearch
      - sls: elasticsearch.backup
      - cmd: elasticsearch_test_create_sample_data
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
    - exclude:
      - elasticsearch_cluster
