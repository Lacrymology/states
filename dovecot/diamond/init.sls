{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
{#- Take a look at /diamond/doc/fail2ban.rst for more details -#}
{%- if salt['pillar.get']('fail2ban:banaction', 'hostsdeny').startswith('iptables') %}
  - firewall
{%- endif %}
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

{%- from 'diamond/macro.jinja2' import fail2ban_count_ip with context %}
{{ fail2ban_count_ip('dovecot') }}
