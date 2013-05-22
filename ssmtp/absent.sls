{#
 Uninstall SSMTP a simple interface to send mail to remote SMTP server
 #}
ssmtp:
  pkg:
    - purged
    - names:
      - ssmtp
      - bsd-mailx
  file:
    - absent
    - name: /etc/ssmtp
    - require:
      - pkg: ssmtp
