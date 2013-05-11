{#
 Configure APT minimal configuration to get Debian packages from repositories.
 #}

{# 99 prefix is to make sure the config file is the last one to be applied #}
/etc/apt/apt.conf.d/99local:
  file:
    - managed
    - source: salt://apt/config.jinja2
    - user: root
    - group: root
    - mode: 444
    - template: jinja

debconf-utils:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

{#
apt_sources_backup:
  file:
    - rename
    - name: /etc/apt/sources.list.bak
    - source: /etc/apt/sources.list
#}

apt_sources:
  file:
    - managed
    - name: /etc/apt/sources.list
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: {{ pillar['apt_source'] }}
    - context:
      all_suites: main restricted universe multiverse
    - require:
      - file: /etc/apt/apt.conf.d/99local
      - file: apt_sources_backup
{#
  cmd.wait is used instead of:

  module:
    - name: pkg.refresh_db

  because the watch directive didn't seem to be respected back in older version.
  this should be test to switch back to module.name instead.
#}
  cmd:
    - wait
    - name: apt-get update
    - watch:
      - file: apt_sources
      - file: /etc/apt/apt.conf.d/99local

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
