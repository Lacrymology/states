{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install a Salt Management Master (server)

 If you install a salt master from scratch, check and run bootstrap_archive.py
 and use it to install the master.
 #}
include:
  - salt
  - git
  - ssh.client
  - pip
  - python.dev
  - rsyslog

salt-master-requirements:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/salt-master-requirements.txt
    - source: salt://salt/master/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/salt-master-requirements.txt
    - watch:
      - file: salt-master-requirements
      - pkg: python-dev
    - require:
      - module: pip

/srv/salt:
  file:
    - directory
    - user: root
    - group: root
    - mode: 555

/srv/salt/top.sls:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/master/top.jinja2
    - require:
      - file: /srv/salt

{%- set version = '0.16.4' -%}
{%- set master_path = '{0}/pool/main/s/salt/salt-master_{0}-1{1}_all.deb'.format(version, grains['lsb_distrib_codename']) %}
salt-master:
  file:
    - managed
    - name: /etc/salt/master
    - source: salt://salt/master/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: salt-master
  pkg:
    - installed
    - skip_verify: True
    - sources:
{%- if 'files_archive' in pillar %}
      - salt-master: {{ pillar['files_archive']|replace('file://', '') }}/mirror/salt/{{ master_path }}
{%- else %}
      - salt-master: http://saltinwound.org/ubuntu/{{ master_path }}
{%- endif %}
    - require:
      - pkg: salt
      - module: salt-master-requirements
  service:
    - running
    - enable: True
    - order: 90
    - require:
      - pkg: git
      - service: rsyslog
    - watch:
      - pkg: salt-master
      - file: salt-master
      - module: salt-master-requirements
