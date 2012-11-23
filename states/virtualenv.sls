include:
  - pip
  - git
  - mercurial

python-virtualenv:
  pkg:
    - installed
    - names:
      - python-virtualenv
      - build-essential
      - python-dev
    - require:
      - pkg: python-pip
      - pkg: git
      - pkg: mercurial
