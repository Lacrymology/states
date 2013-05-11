{{ opts['cachedir'] }}/salt-route53-requirements.txt:
  file:
    - absent

route53:
  pip:
    - removed
