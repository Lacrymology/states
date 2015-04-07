{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

hostname:
  file:
    - managed
    - template: jinja
    - name: /etc/hostname
    - user: root
    - group: root
    - mode: 444
    - contents: {{ grains['id'] }}
  host:
    - present
    - name: {{ grains['id'] }}
    - ip: 127.0.0.1
    - require:
      - cmd: hostname
      - host: localhost
  cmd:
{%- if grains['id'] != grains['localhost'] %}
    - run
{%- else %}
    - wait
{%- endif %}
    - name: hostname `cat /etc/hostname`
    - watch:
      - file: hostname

localhost:
  host:
    - present
    - name: localhost
    - ip: 127.0.0.1

{%- for ip, hostname in salt['pillar.get']('hostname:present', {}).iteritems() %}
hostname_{{ hostname }}_{{ ip }}:
  host:
    - present
    - name: {{ hostname }}
    - ip: {{ ip }}
{%- endfor %}

{%- for ip, hostname in salt['pillar.get']('hostname:absent', {}).iteritems() %}
hostname_{{ hostname }}_{{ ip }}_absent:
  host:
    - absent
    - name: {{ hostname }}
    - ip: {{ ip }}
{%- endfor %}
