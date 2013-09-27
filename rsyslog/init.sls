include:
  - apt

rsyslog:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: remove_klogd_if_exist
      - pkg: gsyslogd
  file:
    - managed
    - name: /etc/rsyslog.conf
    - template: jinja
    - source: salt://rsyslog/config.jinja2
    - require:
      - pkg: rsyslog
  service:
    - running
    - order: 50
    - watch:
      - pkg: rsyslog
      - file: rsyslog
      - file: /etc/rsyslog.d

remove_klogd_if_exist:
  pkg:
    - purged
    - name: klogd
    - require:
      - service: gsyslogd

gsyslogd:
  service:
    - dead
  file:
    - absent
    - name: /etc/init/gsyslogd.conf
    - require:
      - service: gsyslogd
  pkg:
    - purged
    - name: syslogd
    - require:
      - service: gsyslogd

{%- for filename in ('/usr/local/gsyslog', '/etc/gsyslog.d', '/etc/gsyslogd.conf') %}
{{ filename }}:
  file:
    - absent
    - require:
      - file: gsyslogd
{%- endfor %}

/etc/rsyslog.d:
  file:
    - directory
    - clean: True
    - user: root
    - group: root
    - mode: 555
    - require:
      - pkg: rsyslog
