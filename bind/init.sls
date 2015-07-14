{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - resolver

{#- bind formula replaces pdnsd formula, clean up before setting #}
pdnsd:
  pkg:
    - purged
    - require:
      - service: pdnsd
  service:
    - dead
    - enable: False
  user:
    - absent
    - require:
      - pkg: pdnsd

{% for file in ('default/pdnsd', 'pdnsd.conf') %}
/etc/{{ file }}:
  file:
    - absent
    - require:
      - pkg: pdnsd
{% endfor %}

bind:
  pkg:
    - installed
    - name: bind9
    - require:
      - cmd: apt_sources
      - service: pdnsd
  service:
    - running
    - name: bind9
    - require:
      - pkg: bind
      - cmd: dns_resolver

bind_default:
  file:
    - managed
    - name: /etc/default/bind9
    - source: salt://bind/default.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_options_config:
  file:
    - managed
    - name: /etc/bind/named.conf.options
    - source: salt://bind/options.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: bind
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_local_config:
  file:
    - managed
    - name: /etc/bind/named.conf.local
    - source: salt://bind/local.jinja2
    - mode: 640
    - user: root
    - group: bind
    - template: jinja
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_zone_dir:
  file:
    - directory
    - name: /var/lib/bind/zones
    - user: root
    - group: bind
    - mode: 770 {# bind group needs to write to update dynamic DNS #}
    - require:
      - pkg: bind

{%- for zonename in salt['pillar.get']('bind:zones', {}) %}
bind_{{ zonename }}_zone_file:
  file:
    - managed
    - name: /var/lib/bind/zones/{{ salt['pillar.get']("bind:zones:" + zonename + ":file") }}
    - source: salt://bind/zone.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: bind
    - context:
        zonename: {{ zonename }}
        zonedata: {{ salt['pillar.get']('bind:zones:' ~ zonename) }}
    - require:
      - file: bind_zone_dir
    - watch_in:
      - service: bind
{%- endfor %}
