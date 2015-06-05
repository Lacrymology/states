{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - sysctl

openswan:
  pkg:
    - installed
    - pkgs:
      - openswan
      {#- required for ``ipsec verify`` #}
      - lsof
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/ipsec.conf
    - source: salt://openswan/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: openswan
  service:
    - running
    - name: ipsec
    - watch:
      - file: openswan
      - file: /etc/ipsec.secrets
      {#- requires specific pillar key, look in pptpd/doc/pillar.rst #}
      - file: sysctl

/etc/ipsec.secrets:
  file:
    - managed
    - contents: |
        {{ grains['ip_interfaces'][salt['pillar.get']('openswan:public_interface', 'eth0')][0] }}   %any:  PSK "{{ salt['pillar.get']('openswan:shared_secret') }}"
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: openswan

{%- for type in ('send', 'accept') %}
    {%- for interface in salt['file.find']('/proc/sys/net/ipv4/conf/', type='d', print='name') %}
openswan_{{ interface }}_{{ type }}:
  sysctl:
    - present
    - name: net.ipv4.conf.{{ interface }}.{{ type }}_redirects
    - value: 0
    - require_in:
      - service: openswan
    {%- endfor %}
{%- endfor %}
