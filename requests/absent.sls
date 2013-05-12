{{ opts['cachedir'] }}/requests-requirements.txt:
  file:
    - absent

{% if salt['cmd.has_exec']('pip') %}
requests:
  pip:
    - removed
{% endif %}
