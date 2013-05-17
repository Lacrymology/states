{% set version='1.3.1' %}

{{ opts['cachedir'] }}/pip-{{ version }}:
  file:
    - absent

{#
 Only during integration test, we don't want to wipe PIP cache for future usage.
 #}
{% if not pillar['integration_test']|default(False) %}
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

/tmp/pip-build-root:
  file:
    - absent

pip:
  pip:
    - removed
{% endif %}
