include:
  - pip
  - git
  - mercurial

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
