{#
 Install Salt Minion (client)
 #}

salt_minion_master_key:
  module:
    - wait:
    - name: file.absent
    - m_name: /etc/salt/pki/minion/minion_master.pub
    - watch:
      - file: salt-minion

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
      - module: salt_minion_master_key
