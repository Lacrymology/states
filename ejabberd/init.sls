include:
  - apt
  - nginx

{#-
  TODO
    - change ejabberd source
    - support ssl
    - nrpe/diamond
    - nginx support to admin panel
#}
ejabberd_dependencies:
  pkg:
    - installed
    - pkgs:
      - erlang-nox
      - erlang-asn1
      - erlang-base
      - erlang-crypto
      - erlang-inets
      - erlang-mnesia
      - erlang-odbc
      - erlang-public-key
      - erlang-ssl
      - erlang-syntax-tools
    - require:
      - cmd: apt_sources

ejabberd:
  pkg:
    - installed
    - sources:
{%- if 'files_archive' in pillar %}
      - ejabberd: http://ftp.riken.jp/Linux/ubuntu/pool/universe/e/ejabberd/ejabberd_2.1.10-2ubuntu1.3_amd64.deb
{%- else %}
      - ejabberd: http://ftp.riken.jp/Linux/ubuntu/pool/universe/e/ejabberd/ejabberd_2.1.10-2ubuntu1.3_amd64.deb
{%- endif %}
    - require:
      - pkg: ejabberd_dependencies
  service:
    - running
    - name: ejabberd
    - enable: True
    - order: 50
    - require:
      - pkg: ejabberd
    - watch:
      - file: ejabberd
  file:
    - managed
    - name: /etc/ejabberd/ejabberd.cfg
    - source: salt://ejabberd/config.jinja2
    - template: jinja
    - user: ejabberd
    - group: ejabberd
    - mode: 600
    - require:
      - pkg: ejabberd

{%- for user in salt['pillar.get']('ejabberd:admins') %}
{% set password = salt['pillar.get']('ejabberd:admins:' + user) %}
{% set hostname = salt['pillar.get']('ejabberd:hostnames')[0] %}

ejabberd_reg_user_{{ user }}:
  cmd:
    - run
    - name: ejabberdctl register {{ user }} {{ hostname }} {{ password }}
    - user: root
    - unless: ejabberdctl registered_{{ user }} {{ hostname }} | grep {{ user }}
    - require:
      - service: ejabberd
{%- endfor %}

/etc/nginx/conf.d/ejabberd.conf:
  file:
    - managed
    - template: jinja
    - source: salt://ejabberd/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - watch_in:
      - service: nginx
    - require:
      - pkg: nginx
      - service: ejabberd
{%- if salt['pillar.get']('ejabberd:ssl', False) %}
      - cmd: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/chained_ca.crt
      - module: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/server.pem
      - file: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/ca.crt

extend:
  nginx:
    service:
      - watch:
        - cmd: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['ejabberd']['ssl'] }}/ca.crt
{%- endif %}
