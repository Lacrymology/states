{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
        count_workers = True
        [[dovecot-imap]]
        exe = ^\/usr\/lib\/dovecot\/imap$
        count_workers = True
        [[dovecot-imap-login]]
        exe = ^\/usr\/lib\/dovecot\/imap-login$
        count_workers = True
        [[dovecot-pop3]]
        exe = ^\/usr\/lib\/dovecot\/pop3$
        count_workers = True
        [[dovecot-pop3-login]]
        exe = ^\/usr\/lib\/dovecot\/pop3-login$
        count_workers = True
