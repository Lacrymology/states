{{ opts['cachedir'] }}/salt-virtualenv-requirements.txt:
  file:
      - absent

virtualenv:
  pip:
    - removed
