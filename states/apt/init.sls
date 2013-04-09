include:
  - nrpe

/etc/apt/apt.conf.d/99local:
  file:
    - managed
    - source: salt://apt/apt.jinja2
    - user: root
    - group: root
    - mode: 444

debconf-utils:
  pkg:
    - installed

apt_sources:
  file:
    - managed
    - name: /etc/apt/sources.list
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://apt/sources.jinja2
    - context:
      all_suites: main restricted universe multiverse
    - require:
      - file: /etc/apt/apt.conf.d/99local
{#  module:
    - name: pkg.refresh_db#}
  cmd:
    - wait
    - name: apt-get update
    - watch:
      - file: apt_sources

{# remove packages that requires physical hardware on virtual machines #}
{% if grains['virtual'] == 'xen' or grains['virtual'] == 'Parallels' or grains['virtual'] == 'openvzve' %}
apt_cleanup:
  pkg:
    - purged
    - names:
      - acpid
      - eject
      - hdparm
      - memtest86+
      - usbutils
{% endif %}

/usr/local/bin/check_apt-rc.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_apt-rc.py:
  file:
    - managed
    - source: salt://apt/check.py
    - mode: 555
    - require:
      - pip: nagiosplugin

/etc/nagios/nrpe.d/apt.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://apt/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/apt.cfg
