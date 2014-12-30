{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
requests:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/pip/requests

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/requests-requirements.txt:
 file:
   - absent
