include:
  - apt

rsyslog:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: remove_klogd_if_exist
      - pkg: remove_syslogd_if_exist
  file:
    - managed
    - name: /etc/rsyslog.conf
    - template: jinja
    - source: salt://rsyslog/config.jinja2
  service:
    - running
    - watch:
      - pkg: rsyslog
      - file: rsyslog
      - file: /etc/rsyslog.d

remove_klogd_if_exist:
  pkg:
    - purged
    - name: klogd

remove_syslogd_if_exist:
  pkg:
    - purged
    - name: syslogd

/etc/rsyslog.d:
  file:
    - directory
    - clean: True
