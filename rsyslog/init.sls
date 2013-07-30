include:
  - apt

rsyslog:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: remove_klogd_if_exist
      - pkg: gsyslog
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
    - require:
      - service: gsyslog

gsyslog:
  service:
    - dead
    - name: gsyslog
  file:
    - absent
    - name: /etc/init/gsyslogd.conf
    - require:
      - service: gsyslog
  pkg:
    - purged
    - name: syslogd
    - require:
      - service: gsyslog

/etc/rsyslog.d:
  file:
    - directory
    - clean: True
