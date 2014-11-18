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

/etc/cron.d/mail-server-nrpe:
  file:
    - absent
    - watch_in:
      - service: cron

/usr/lib/nagios/plugins/check_mail_stack.py:
  file:
{%- if salt['pillar.get']('mail:check_mail_stack', False) %}
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
    - absent
{%- endif -%}
