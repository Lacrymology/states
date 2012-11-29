{# TODO: send logs to GELF #}
include:
  - git
  - virtualenv
  - nrpe

/etc/diamond/collectors:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

diamond_upstart:
  file:
    - managed
    - name: /etc/init/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/upstart.jinja2

diamond:
  virtualenv:
    - manage
    - upgrade: True
    - name: /usr/local/diamond
  pip:
    - installed
    - name: ''
    - upgrade: True
    - requirements: salt://diamond/requirements.txt
    - require:
      - pkg: git
      - pkg: python-virtualenv
      - file: diamond_upstart
  file:
    - managed
    - name: /etc/diamond/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/config.jinja2
    - require:
      - virtualenv: diamond
  service:
    - running
    - watch:
      - virtualenv: diamond
      - file: diamond
      - file: diamond_upstart
      - pip: diamond

{#
archive of installation trough debian package

diamond:
  pkg:
    - installed
  file.managed:
    - name: /etc/diamond/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://diamond/config.jinja2
    - require:
      - pkg: diamond
  service:
    - running
    - watch:
      - pkg: diamond
      - file: /etc/diamond/diamond.conf
#}

/etc/nagios/nrpe.d/diamond.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://diamond/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/diamond.cfg
