include:
  - salt
  - git

salt-master:
  git:
    - managed
    - latest: True
    - target: /etc/salt/
  pkg:
    - latest
  service:
    - running
    - watch:
      - pkg: salt-master
