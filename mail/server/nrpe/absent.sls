{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/usr/lib/nagios/plugins/check_mail_stack.py:
  file:
    - absent

/etc/cron.d/mail-server-nrpe:
  file:
    - absent
