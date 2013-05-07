{% set version='1.3.1' %}

{{ opts['cachedir'] }}/pip-{{ version }}:
  file:
    - absent
