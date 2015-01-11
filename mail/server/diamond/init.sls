{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - diamond
  - postfix

/etc/diamond/collectors/MailCollector.conf:
  file:
    - managed
    - source: salt://mail/server/diamond/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/diamond/collectors
      - file: /usr/local/diamond/share/diamond/collectors/mail/mail.py
      - service: postfix
    - watch_in:
      - service: diamond

/usr/local/diamond/share/diamond/collectors/mail:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - virtualenv: diamond

/usr/local/diamond/share/diamond/collectors/mail/mail.py:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - source: salt://mail/server/diamond/collector.py
    - require:
      - file: /usr/local/diamond/share/diamond/collectors/mail
