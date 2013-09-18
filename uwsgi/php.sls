include:
  - apt
  - php.dev
  - uwsgi

{%- if grains['osrelease']|float == 12.04 %}
symlink-libphp5.so:
  file:
    - symlink
    {%- if grains['cpuarch'] == 'i686' %}
    - name: /usr/lib/i386-linux-gnu/libphp5.so
    {%- else %}
    - name: /usr/lib/x86_64-linux-gnu/libphp5.so
    {%- endif %}
    - target: /usr/lib/php5/libphp5.so
    - require:
      - pkg: php-dev

/usr/local/uwsgi/plugins/php/uwsgiplugin.py:
  file:
    - managed
    - source: salt://uwsgi/php_uwsgiplugin.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
{%- if 'files_archive' in pillar -%}
      - archive: uwsgi_build
{%- else -%}
      - git: uwsgi_build
{%- endif %}
{%- endif %}

extend:
  uwsgi_build:
    file:
      - require:
        - pkg: php-dev
{% if grains['osrelease']|float == 12.04 %}
    cmd:
      - watch:
        - file: symlink-libphp5.so
        - file: /usr/local/uwsgi/plugins/php/uwsgiplugin.py
{% endif %}
