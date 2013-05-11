/etc/apt/apt.conf.d/99local:
  file:
    - absent

debconf-utils:
  pkg:
    - purged

apt_sources:
  file:
    - rename
    - name: /etc/apt/sources.list
    - source: /etc/apt/sources.list.bak
    - force: True
  cmd:
    - wait
    - name: apt-get update
    - watch:
      - file: apt_sources
      - file: /etc/apt/apt.conf.d/99local
