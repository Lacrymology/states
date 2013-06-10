include:
  - shinken
  - apt

nagios-nrpe-plugin:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

shinken-poller:
  file:
    - managed
    - name: /etc/init/shinken-poller.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: poller
  service:
    - running
    - enable: True
    - require:
      - file: /var/lib/shinken
      - file: /var/log/shinken
      - pkg: nagios-nrpe-plugin
    - watch:
      - module: shinken
      - file: /etc/shinken/poller.conf
      - file: shinken-poller

/etc/shinken/poller.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
      shinken_component: poller
    - require:
      - virtualenv: shinken
      - user: shinken
