{%- set ssl = salt['pillar.get']('redirect:ssl', False) -%}

include:
  - nginx
{%- if ssl %}
  - ssl
{%- endif %}

/etc/nginx/conf.d/redirect.conf:
  file:
    - managed
    - template: jinja
    - source: salt://redirect/nginx.jinja2
    - user: root
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
    - context:
        ssl: {{ ssl }}

{% if ssl %}
extend:
  nginx:
    service:
      - watch:
        - cmd: ssl_cert_and_key_for_{{ ssl }}
  nginx.conf:
    file:
      - context:
          ssl: {{ ssl }}
{% endif %}
