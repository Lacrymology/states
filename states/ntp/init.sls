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
      - pkg: ntp
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

ntp_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[ntp]]
        exe = ^\/usr\/sbin\/ntpd$

diamond_ntp:
  file:
    - managed
    - name: /etc/diamond/collectors/NtpdCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/basic_collector.jinja2

extend:
  diamond:
    service:
      - watch:
        - file: diamond_ntp
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ntpd.cfg
