{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
/etc/update-motd.d/10-help-text:
  file:
     - absent

/etc/motd.tail:
   file:
     - managed
     - template: jinja
     - user: root
     - group: root
     - mode: 444
     - source: salt://motd/config.jinja2
   cmd:
     - wait
     - name: run-parts /etc/update-motd.d/ > /etc/motd
     - watch:
       - file: /etc/update-motd.d/10-help-text
       - file: /etc/motd.tail
