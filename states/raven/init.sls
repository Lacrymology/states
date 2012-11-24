include:
  - pip

raven:
  pip:
    - installed
    - upgrade: True
    - name: raven
    - requirements: salt://raven/requirements.txt
    - require:
      - pkg: python-pip
