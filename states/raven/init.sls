include:
  - pip

raven:
  pip:
    - installed
    - name: raven
    - requirements: salt://raven/requirements.txt
    - require:
      - pkg: python-pip
