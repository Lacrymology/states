include:
  - pip

raven:
  pip:
    - installed
    - upgrade: True
    - name: ''
    - requirements: salt://raven/requirements.txt
    - require:
      - pkg: python-pip
