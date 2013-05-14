{#
 Install a gsyslogd server, it's a sysklogd/rsyslog replacement
#}
include:
  - virtualenv
  - pip
  - apt
  - python.dev

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
    - require:
      - cmd: apt_sources
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
    - require:
      - cmd: apt_sources
  virtualenv:
    - managed
    - name: /usr/local/gsyslog
    - require:
      - module: virtualenv
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - requirements: /usr/local/gsyslog/salt-requirements.txt
    - bin_env: /usr/local/gsyslog
    - require:
      - virtualenv: gsyslog
    - watch:
      - pkg: gsyslog
      - pkg: python-dev
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

rsyslog:
{# as soon as https://github.com/saltstack/salt/issues/4972 is fixed
   the following is unnecessary #}
  cmd:
    - wait
    - name: dpkg --purge rsyslog
    - watch:
      - module: sysklogd
{#
  pkg:
    - purged
    - require:
      - module: sysklogd
#}
 file:
    - absent
    - name: /var/log/upstart/rsyslog.log
    - require:
      - cmd: rsyslog
{#      - pkg: rsyslog#}

{% for cron in ('weekly', 'daily') %}
/etc/cron.{{ cron }}/sysklogd:
  file:
    - absent
    - require:
      - module: sysklogd
{% endfor %}
