{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

backup-elasticsearch:
  file:
    - absent
    - name: /etc/cron.daily/backup-elasticsearch

esclient:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/elasticsearch.backup
