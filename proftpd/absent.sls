{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn

 Uninstall a ProFTPd FTP server.
-#}
proftpd:
  pkg:
    - purged
    - pkgs:
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
{% for deployment in salt['pillar.get']('proftpd:deployments', []) %}
/var/lib/deployments/{{ deployment }}/static/ftp:
  file:
    - absent
{% endfor %}
{% endif %}
