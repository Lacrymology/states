{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - python.dev
  - local
  - virtualenv

glances:
  virtualenv:
    - manage
    - upgrade: True
    - name: /usr/local/glances
    - require:
      - file: /usr/local
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/glances
    - requirements: /usr/local/glances/salt-requirements.txt
    - require:
      - virtualenv: glances
    - watch:
      - file: glances
  file:
    - managed
    - name: /usr/local/glances/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://glances/requirements.jinja2
    - require:
      - virtualenv: glances

/usr/local/bin/glances:
  file:
    - symlink
    - target: /usr/local/glances/bin/glances
    - require:
      - module: glances
