{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

hostname:
  file:
    - managed
    - template: jinja
    - name: /etc/hostname
    - user: root
    - group: root
    - mode: 644
    - contents: {{ grains['id'] }}
  host: {#- API #}
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

{%- for ip, hostnames in salt['pillar.get']('hostname:present', {}).iteritems() %}
  {%- for hostname in hostnames %}
hostname_{{ hostname }}_{{ ip }}:
  host:
    - present
    - name: {{ hostname }}
    - ip: {{ ip }}
    - require_in:
      - host: hostname
  {%- endfor %}
{%- endfor %}

{%- for ip, hostname in salt['pillar.get']('hostname:absent', {}).iteritems() %}
  {%- for hostname in hostnames %}
hostname_{{ hostname }}_{{ ip }}_absent:
  host:
    - absent
    - name: {{ hostname }}
    - ip: {{ ip }}
    - require_in:
      - host: hostname
  {%- endfor %}
{%- endfor %}
