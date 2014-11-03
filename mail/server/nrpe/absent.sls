/usr/lib/nagios/plugins/check_mail_stack.py:
  file:
    - absent

/etc/cron.d/mail-server-nrpe:
  file:
    - absent
