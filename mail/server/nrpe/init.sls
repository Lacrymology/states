{#
 Monitoring check to test the entire mail stack (IMAP, SMTP, LDAP, antivirus,
 antispam, etc.
 #}
include:
  - cron
  - nrpe

/etc/nagios/check_mail_stack.yml:
  file:
    - absent

{%- set check_mail_stack = salt['pillar.get']('mail:check_mail_stack', {}) -%}
{%- if check_mail_stack is mapping and check_mail_stack|length > 0 -%}
{%- from 'nrpe/passive.sls' import passive_check with context %}

{{ passive_check('mail.server') }}

/etc/cron.d/mail-server-nrpe:
  file:
    - absent
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
{%- else -%}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}

{{ passive_absent('mail.server') }}

/usr/lib/nagios/plugins/check_mail_stack.py:
  file:
    - absent
{%- endif -%}
