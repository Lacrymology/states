include:
  - virtualenv
  - nrpe
  - diamond
  - pip

{# gsyslog depends on klogd to get kernel logs #}
sysklogd:
  pkg:
    - latest
    - names:
      - sysklogd
      - klogd
  module:
    - wait
    - name: cmd.run
    - m_name: /etc/init.d/sysklogd stop
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
      - service: sysklogd

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
  service:
    - running
    - enable: True
    - name: gsyslogd
    - watch:
      - file: gsyslog_upstart
      - virtualenv: gsyslog
      - file: gsyslog
      - cmd: gsyslog
    - require:
      - module: sysklogd
      - module: gsyslog
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

gsyslog_diamond_memory:
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

rsyslog:
  pkg:
    - purged
    - require:
      - service: sysklogd

{% for cron in ('weekly', 'daily') %}
/etc/cron.{{ cron }}/sysklogd:
  file:
    - absent
    - require:
      - service: sysklogd
{% endfor %}

/etc/nagios/nrpe.d/gsyslog.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://gsyslog/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/gsyslog.cfg
