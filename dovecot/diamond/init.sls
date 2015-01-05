{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}

include:
  - diamond
  - postfix.diamond
  - rsyslog.diamond

dovecot_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[dovecot]]
        exe = ^\/usr\/sbin\/dovecot$

/etc/diamond/collectors/MailCollector.conf:
  file:
    - managed
    - source: salt://dovecot/diamond/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/diamond/collectors
      - service: dovecot
      - file: /usr/local/diamond/share/diamond/collectors/mail/mail.py
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
    - source: salt://dovecot/diamond/collector.py
    - require:
      - file: /usr/local/diamond/share/diamond/collectors/mail
