{#
 Uninstall SSMTP a simple interface to send mail to remote SMTP server
 #}
ssmtp:
  pkg:
    - purged
    - pkgs:
      - bsd-mailx
      - ssmtp
  file:
    - absent
    - name: /etc/ssmtp
    - require:
      - pkg: ssmtp
