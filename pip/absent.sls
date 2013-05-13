{% set version='1.3.1' %}

{{ opts['cachedir'] }}/pip-{{ version }}:
  file:
    - absent

{% if pillar['pip_no_purge_cache']|default(False) %}
/var/cache/pip:
  file:
    - absent
{% endif %}

{{ salt['user.info']('root')['home'] }}/.pip:
  file:
    - absent

python-setuptools:
  pkg:
    - purged
{% if salt['cmd.has_exec']('pip') %}
    - require:
      - pip: pip

pip:
  pip:
    - removed
{% endif %}
