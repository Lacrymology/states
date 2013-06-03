include:
  - salt.minion

/etc/salt/minion.d/nrpe.conf:
  file:
    - absent

extend:
  salt-minion:
    service:
      - watch:
        - file: /etc/salt/minion.d/nrpe.conf
