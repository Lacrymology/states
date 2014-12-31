{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Nicolas Plessis <niplessis@gmail.com>
Maintainer: Nicolas Plessis <niplessis@gmail.com>
-#}

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
