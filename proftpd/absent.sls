{#
 Uninstall a ProFTPd FTP server.
#}
proftpd:
  pkg:
    - purged
    - names:
      - proftpd-basic
      - proftpd-mod-pgsql
    - require:
      - service: proftpd
  service:
    - dead
    - enable: False

/var/log/proftpd:
  file:
    - absent
    - require:
      - pkg: proftpd

/etc/proftpd:
  file:
    - absent
    - require:
      - pkg: proftpd

{% if pillar['destructive_absent']|default(False) %}
{% for deployment in pillar['proftpd']['deployments'] %}
/var/lib/deployments/{{ deployment }}/static/ftp:
  file:
    - absent
{% endfor %}
{% endif %}
