{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Shinken Poller state.

 The poller daemon launches check plugins as requested by schedulers. When the
 check is finished it returns the result to the schedulers. Pollers can be
 tagged for specialized checks (ex. Windows versus Unix, customer A versus
 customer B, DMZ) There can be many pollers for load-balancing or hot standby
 spare roles.
 -#}
include:
  - shinken
  - apt
  - nrpe

nagios-nrpe-plugin:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: nagios-plugins

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
    - order: 50
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
