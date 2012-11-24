include:
  - pip

requests:
  pip:
    - installed
    - upgrade: True
  require:
    - pkg: python-pip
