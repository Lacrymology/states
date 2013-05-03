{#
 Install Salt Minion (client)
 #}
salt-minion:
  apt_repository:
    - ubuntu_ppa
    - user: saltstack
    - name: salt
    - key_id: 0E27C0A6
  file:
    - managed
    - template: jinja
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/minion/config.jinja2
    - require:
      - pkg: salt-minion
  pkg:
    - installed
    - names:
      - python-openssl
      - salt-minion
    - require:
      - apt_repository: salt-minion
  service:
    - running
    - enable: True
    - watch:
      - pkg: salt-minion
      - file: salt-minion
