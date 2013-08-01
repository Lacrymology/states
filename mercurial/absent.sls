{{ opts['cachedir'] }}/salt-mercurial-requirements.txt:
  file:
      - absent

{% if salt['cmd.has_exec']('pip') %}
mercurial:
  pip:
    - removed
    - order: 1
{% endif %}
