{{ opts['cachedir'] }}/requests-requirements.txt:
  file:
    - absent

requests:
  pip:
    - removed
