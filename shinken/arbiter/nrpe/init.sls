{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Nagios NRPE check for Shinken Arbiter
-#}
include:
  - apt.nrpe
  - nrpe
  - pip.nrpe
  - python.dev.nrpe
{% if pillar['shinken']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
  - ssmtp.nrpe
  - virtualenv.nrpe

/etc/nagios/nrpe.d/shinken-arbiter.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://shinken/arbiter/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/shinken-arbiter.cfg
