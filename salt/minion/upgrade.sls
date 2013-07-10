{#-
 This state is the most simple way to upgrade to restart a minion.
 It don't requires on any other state (sls) file except salt
 (for the repository).

 It's kept at the minion to make sure it don't change anything else during the
 upgrade process.
-#}

include:
  - apt
  - salt

salt-minion:
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
    - latest
  service:
    - running
    - enable: True
    - watch:
      - pkg: salt-minion
      - file: salt-minion
