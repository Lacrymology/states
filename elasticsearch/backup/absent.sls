{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Luan Vo Ngoc <luan@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
backup-elasticsearch:
  file:
    - absent
    - name: /etc/cron.daily/backup-elasticsearch

esclient:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/elasticsearch.backup
