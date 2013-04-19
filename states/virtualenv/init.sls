{#
 Install all dependencies to create Python's virtualenv.
 #}
include:
  - pip
  - git
  - mercurial

python-virtualenv:
  pkg:
    - purged

virtualenv:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/salt-virtualenv-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - requirements: {{ opts['cachedir'] }}/salt-virtualenv-requirements.txt
    - watch:
      - file: virtualenv
    - require:
      - module: pip
      - pkg: git
      - pkg: mercurial

{% if 'backup_server' in pillar %}
/usr/local/bin/backup-pip:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://virtualenv/backup.jinja2
{% endif %}
