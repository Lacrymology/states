{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/etc/mailname:
  file:
    - managed
    - source: salt://mail/mailname.jinja2
    - template: jinja

host_{{ salt['pillar.get']('mail:mailname') }}:
  host:
    - present
    - name: {{ salt['pillar.get']('mail:mailname') }}
    - ip: 127.0.0.1
