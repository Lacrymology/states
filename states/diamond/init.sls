{# TODO: send logs to GELF #}
include:
  - git
  - virtualenv
  - nrpe

diamond_upstart:
  file:
    - managed
    - name: /etc/init/diamond.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://diamond/upstart.jinja2

diamond:
  virtualenv:
    - manage
    - name: /usr/local/diamond
    - no_site_packages: True
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
    - mode: 644
    - source: salt://diamond/config.jinja2
    - require:
      - virtualenv: diamond
  service:
    - running
    - watch:
      - virtualenv: diamond
      - file: diamond
      - file: diamond_upstart

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
    - mode: 600
    - source: salt://diamond/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/diamond.cfg
