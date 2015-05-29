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

proftpd_fake_mail_path:
  # postrm script of proftpd-basic logs error if it cannot delete mail
  # dir/files of that user.
  # So this create fake one for those users to avoid error log when absent runs
  file:
    - managed
    - name: /var/mail/proftpd
    - makedirs: True
    - replace: False
    - require:
      - service: proftpd
    - require_in:
      - pkg: proftpd

proftpd_fake_mail_path_ftp:
  file:
    - managed
    - name: /var/mail/ftp
    - makedirs: True
    - replace: False
    - require:
      - service: proftpd
    - require_in:
      - pkg: proftpd

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
