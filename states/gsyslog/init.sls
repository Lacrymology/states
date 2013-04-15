{#
 Install a gsyslogd server, it's a sysklogd/rsyslog replacement
#}
include:
  - virtualenv
  - nrpe
  - diamond
  - pip

{#
 gsyslog depends on klogd to get kernel logs, which is in sysklogd.
 install sysklogd, but disable everything except klogd.
#}
sysklogd:
  pkg:
    - latest
    - names:
      - sysklogd
      - klogd
  module:
    - wait
    - name: cmd.run
    - cmd: /etc/init.d/sysklogd stop
    - watch:
      - pkg: sysklogd
  cmd:
    - wait
    - name: update-rc.d -f sysklogd remove
    - require:
      - module: sysklogd
    - watch:
      - pkg: sysklogd

{% if grains['virtual'] == 'openvzve' %}
klogd:
  service:
    - dead
    - enable: False
{% endif %}

/etc/gsyslog.d:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

gsyslog_upstart:
  file:
    - managed
    - name: /etc/init/gsyslogd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://gsyslog/upstart.jinja2
    - require:
      - module: sysklogd

/etc/logrotate.d/gsyslog:
  file:
    - absent

gsyslog_requirements:
  file:
    - managed
    - name: /usr/local/gsyslog/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://gsyslog/requirements.jinja2
    - require:
      - virtualenv: gsyslog

gsyslog:
  pkg:
    - latest
    - name: libevent-dev
  virtualenv:
    - managed
    - name: /usr/local/gsyslog
    - require:
      - pkg: python-virtualenv
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - requirements: /usr/local/gsyslog/salt-requirements.txt
    - bin_env: /usr/local/gsyslog
    - require:
      - virtualenv: gsyslog
      - pkg: python-virtualenv
      - pkg: gsyslog
      - file: pip-cache
    - watch:
      - file: gsyslog_requirements
  file:
    - managed
    - name: /etc/gsyslogd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://gsyslog/config.jinja2
    - require:
      - file: /etc/gsyslog.d
  service:
    - running
    - enable: True
    - name: gsyslogd
    - watch:
      - file: gsyslog_upstart
      - virtualenv: gsyslog
      - file: gsyslog
      - cmd: gsyslog
      - module: gsyslog
    - require:
      - module: sysklogd
      - file: /etc/gsyslog.d
  cmd:
    - wait
    - name: find /usr/local/gsyslog -name '*.pyc' -delete
    - stateful: False
    - watch:
      - module: gsyslog

/etc/gsyslog.d:
  file:
    - directory
    - user: root
    - group: root
    - mode: 555

gsyslog_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[gsyslog]]
        cmdline = ^\/usr\/local\/gsyslog\/bin\/python \/usr\/local\/gsyslog\/bin\/gsyslogd
        [[klogd]
        exe = ^\/sbin\/klogd

rsyslog:
  pkg:
    - purged
    - require:
      - module: sysklogd

{% for cron in ('weekly', 'daily') %}
/etc/cron.{{ cron }}/sysklogd:
  file:
    - absent
    - require:
      - module: sysklogd
{% endfor %}

/etc/nagios/nrpe.d/gsyslog.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://gsyslog/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gsyslog.cfg
