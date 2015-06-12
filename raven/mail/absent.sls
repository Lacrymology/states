{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/usr/bin/mail:
  file:
    - absent

{%- if salt['file.file_exists']('/etc/alternatives/mail') %}
update-alternatives-mailx:
  module:
    - run
    - name: alternatives.auto
    - m_name: mailx
    - require:
      - file: /usr/bin/mail
    - require_in:
      - cmd: cron_sendmail_unpatch
{%- endif %}

/usr/bin/ravenmail:
  file:
    - absent

cron_sendmail_unpatch:
  cmd:
    - wait
    - name: perl -pi -e "s|/usr/bin/ravenmail|/usr/sbin/sendmail|" /usr/sbin/cron
    - unless: grep -a sendmail /usr/sbin/cron
    - watch:
      - file: /usr/bin/mail
