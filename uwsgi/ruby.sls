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
