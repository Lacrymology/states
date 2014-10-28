{#
 Monitoring check to test the entire mail stack (IMAP, SMTP, LDAP, antivirus,
 antispam, etc.
 #}
{%- from 'nrpe/passive.sls' import passive_check with context %}
include:
  - nrpe

{{ passive_check('mail.server') }}

/etc/nagios/check_mail_stack.yml:
  file:
    - absent

{%- if salt['pillar.get']('mail:check_mail_stack', False) %}
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
