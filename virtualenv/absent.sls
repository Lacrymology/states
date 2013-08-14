virtualenv:
  file:
    - absent
    - name: {{ opts['cachedir'] }}/salt-virtualenv-requirements.txt
{% if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{% endif %}
