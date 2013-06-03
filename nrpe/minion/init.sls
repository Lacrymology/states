{#
 Salt-Minion Integration to publish in salt mine data used for monitoring
 #}

include:
  - salt.minion

/etc/salt/minion.d/nrpe.conf:
  file:
    - managed
    - source: salt://nrpe/minion/config.jinja2
    - user: root
    - group: root
    - mode: 440

extend:
  salt-minion:
    service:
      - watch:
        - file: /etc/salt/minion.d/nrpe.conf
