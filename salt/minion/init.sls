{#
 Install Salt Minion (client)
 #}

include:
  - gsyslog
  - salt.minion.upgrade

{# it's mandatory to remove this file if the master is changed #}
salt_minion_master_key:
  module:
    - wait
    - name: file.remove
    - path: /etc/salt/pki/minion/minion_master.pub
    - watch:
      - file: salt-minion

salt_minion_dependencies:
  pkg:
    - installed
    - pkgs:
      - lsb-release
{% if grains['virtual'] != 'openvzve' %}
      - pciutils
      - dmidecode
{% endif %}
    - require:
      - cmd: apt_sources

{%- set version = salt['pillar.get']('salt:version', '0.15.3') -%}
{%- set minion_path = '{0}/pool/main/s/salt/salt-minion_{0}-1{1}_all.deb'.format(version, grains['lsb_codename']) %}

salt-minion:
  file:
    - managed
    - template: jinja
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/minion/config.jinja2
    - require:
      - pkg: salt-minion
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - salt-minion: {{ pillar['files_archive'] }}/mirror/salt/{{ minion_path }}
{%- else %}
      - salt-minion: http://saltinwound.org/ubuntu/{{ minion_path }}
{%- endif %}
    - require:
      - pkg: salt-common
      - pkg: debconf-utils
      - pkg: python-software-properties
      - pkg: salt_minion_dependencies
  service:
    - running
    - enable: True
    - require:
      - service: gsyslog
    - watch:
      - pkg: salt-minion
      - file: salt-minion
      - module: salt_minion_master_key

{{ opts['cachedir'] }}/pkg_installed.pickle:
  file:
    - absent

extend:
  salt-minion:
    service:
      - require:
        - service: gsyslog
      - watch:
        - module: salt_minion_master_key
    pkg:
      - names:
        - salt-minion
        - lsb-release
{%- if grains['virtual'] != 'openvzve' %}
        - pciutils
        - dmidecode
{%- endif %}
      - require:
        - apt_repository: salt
        - cmd: apt_sources
        - pkg: debconf-utils
        - pkg: python-software-properties
