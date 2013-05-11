{% set version='1.3.1' %}

{{ opts['cachedir'] }}/pip-{{ version }}:
  file:
    - absent

/var/cache/pip:
  file:
    - absent

python-setuptools:
  pkg:
    - purged
    - require:
      - pip: pip

{{ salt['user.info']('root')['home'] }}/.pip:
  file:
    - absent

pip:
  pip:
    - removed

