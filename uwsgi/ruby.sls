{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - ruby
  - uwsgi

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: ruby
    cmd:
      - watch:
        - pkg: ruby
