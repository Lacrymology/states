include:
  - hostname
  - shinken
  - ssmtp

{#{% if 'arbiter' in pillar['shinken']['roles'] %}#}
{#    {% if pillar['shinken']['arbiter']['use_mongodb'] %}#}
{#  - mongodb#}
{#    {% endif %}#}
{#{% endif %}#}

{% set configs = ('architecture', 'infra') %}

shinken-arbiter:
  file:
    - managed
    - name: /etc/init/shinken-arbiter.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/arbiter/upstart.jinja2
    - require:
      - pkg: ssmtp
      - host: hostname
  service:
    - running
    - enable: True
    - require:
      - file: /var/log/shinken
      - file: /var/lib/shinken
    - watch:
      - module: shinken
      - file: shinken-arbiter
      - file: /etc/shinken/arbiter.conf
    {% for config in configs %}
      - file: /etc/shinken/{{ config }}.conf
    {% endfor %}

/etc/shinken/arbiter.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/arbiter/config.jinja2
    - context:
      configs:
{% for config in configs %}
        - {{ config }}
{% endfor %}
    - require:
      - file: /etc/shinken
      - user: shinken

/etc/shinken/objects:
  file:
    - directory
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 550
    - require:
      - file: /etc/shinken
      - user: shinken

{% for config in configs %}
/etc/shinken/{{ config }}.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/{{ config }}.jinja2
    - require:
      - file: /etc/shinken
      - user: shinken
{% endfor %}
