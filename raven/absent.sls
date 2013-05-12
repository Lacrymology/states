{{ opts['cachedir'] }}/salt-raven-requirements.txt:
  file:
    - absent

{% if salt['cmd.has_exec']('pip') %}
raven:
  pip:
    - removed
{% endif %}
