{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

proftpd-users:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/proftpd.sql

{% for deployment in salt['pillar.get']('proftpd:accounts', {}) %}
/var/lib/deployments/{{ deployment }}/static/ftp:
  file:
    - absent
{% endfor %}
