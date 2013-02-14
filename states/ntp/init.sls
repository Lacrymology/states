include:
  - apt
  - diamond
  - nrpe

{% if 'servers' in pillar['ntp'] %}
ntpdate:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/default/ntpdate
    - template: jinja
    - source: salt://ntp/ntpdate.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: ntpdate
    - context: {{ pillar['ntp'] }}
{% endif %}

ntp:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/ntp.conf
    - template: jinja
    - source: salt://ntp/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: ntpd
    - context: {{ pillar['ntp'] }}
  service:
    - running
    - require:
      - pkg: ntp
    - watch:
      - file: ntp

/etc/nagios/nrpe.d/ntpd.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://ntp/nrpe.jinja2

ntp_diamond_memory:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessMemoryCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessMemoryCollector.conf
    - text:
      - |
        [[ntp]]
        exe = ^\/usr\/sbin\/ntpd$

extend:
  diamond:
    service:
      - watch:
        - file: ntp_diamond_memory
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ntpd.cfg
