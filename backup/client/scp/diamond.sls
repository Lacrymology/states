{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - backup.diamond
{%- if salt['pillar.get']('backup_server:address') in grains['ipv4'] or
       salt['pillar.get']('backup_server:address') in ('localhost', grains['host']) %}
  {#- If backup_server address set to localhost (mainly in CI testing), install backup.server first #}
  - backup.server.diamond
{%- endif %}
