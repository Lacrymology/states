{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - python.dev
  - local
  - virtualenv

/usr/local/glances/salt-requirements.txt:
  file:
    - absent

glances:
  virtualenv:
    - manage
    - name: /usr/local/glances
    - require:
      - file: /usr/local
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/glances
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://glances/requirements.jinja2
    - require:
      - virtualenv: glances
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/glances
    - requirements: {{ opts['cachedir'] }}/pip/glances
    - require:
      - virtualenv: glances
    - watch:
      - file: glances

/usr/local/bin/glances:
  file:
    - symlink
    - target: /usr/local/glances/bin/glances
    - require:
      - module: glances
