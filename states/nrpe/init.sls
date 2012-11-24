{# Nagios NRPE Agent #}

include:
  - pip
  - mercurial

nagios-nrpe-server:
  pkg:
    - latest
    - names:
      - nagios-nrpe-server
      - nagios-plugins-standard
      - nagios-plugins-basic
  pip:
    - installed
    - upgrade: True
    - repo: hg+https://bitbucket.org/gocept/nagiosplugin#egg=nagiosplugin
    - require:
      - pkg: python-pip
  file:
    - managed
    - name: /etc/nagios/nrpe.d/000-nagios-servers.cfg
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
  service:
    - running
    - watch:
      - pkg: nagios-nrpe-server
      - file: nagios-nrpe-server
