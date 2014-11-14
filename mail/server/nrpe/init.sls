{#
 Monitoring check to test the entire mail stack (IMAP, SMTP, LDAP, antivirus,
 antispam, etc.
 #}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - cron
  - nrpe

{{ passive_check('mail.server') }}

/etc/nagios/check_mail_stack.yml:
  file:
    - absent

{%- if salt['pillar.get']('mail:check_mail_stack', False) %}
/etc/cron.d/mail-server-nrpe:
  file:
    - managed
    - source: salt://mail/server/nrpe/cron.jinja2
    - user: root
    - group: root
    - template: jinja
    - mode: 400
    - require:
      - pkg: cron
      - file: /usr/lib/nagios/plugins/check_mail_stack.py
    - watch_in:
      - service: cron

/usr/lib/nagios/plugins/check_mail_stack.py:
  file:
    - managed
    - source: salt://mail/server/nrpe/check_mail_stack.py
    - user: nagios
    - group: nagios
    - mode: 550
    - require:
      - module: nrpe-virtualenv
      - pkg: nagios-nrpe-server
      - file: nsca-mail.server
    - require_in:
      - service: nagios-nrpe-server
      - service: nsca_passive
{%- else %}
/usr/lib/nagios/plugins/check_mail_stack.py:
  file:
    - absent
{%- endif -%}
