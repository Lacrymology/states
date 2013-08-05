requests:
  file:
    - absent
    - file: {{ opts['cachedir'] }}/requests-requirements.txt
{%- if salt['cmd.has_exec']('pip') %}
  pip:
    - removed
    - order: 1
{%- endif %}
