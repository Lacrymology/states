{#
 Install all dependencies to create Python's virtualenv.
 #}
include:
  - pip
  - git
  - mercurial
  - apt

python-virtualenv:
  pkg:
    - latest
    - names:
      - python-virtualenv
      - build-essential
      - python-dev
    - require:
      - pkg: python-pip
      - pkg: git
      - pkg: mercurial
      - cmd: apt_sources

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
