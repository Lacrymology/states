{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

hostname:
  file:
    - managed
    - template: jinja
    - name: /etc/hostname
    - user: root
    - group: root
    - mode: 444
    - source: salt://hostname/hostname.jinja2
  host:
    - present
    - name: {{ grains['id'] }}
    - ip: 127.0.0.1
    - require:
      - cmd: hostname
  cmd:
{%- if grains['id'] != grains['localhost'] %}
    - run
{%- else %}
    - wait
{%- endif %}
    - name: hostname `cat /etc/hostname`
    - watch:
      - file: hostname
