/etc/apt/apt.conf.d/99local:
  file:
    - managed
    - source: salt://apt/apt.jinja2
    - user: root
    - group: root
    - mode: 444

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
  module:
    - wait
    - name: pkg.refresh_db
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
