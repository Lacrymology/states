include:
  - apt

{%- set user = salt['pillar.get']('ejabberd:user', 'xmppadmin') %}
{%- set password = salt['pillar.get']('ejabberd:password', 'password') %}
{%- set hostname = salt['pillar.get']('ejabberd:hostname', salt['network.ip_addrs']('eth0')[0]) %}

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
      - ejabberd: http://launchpadlibrarian.net/156862939/ejabberd_2.1.10-2ubuntu1.3_i386.deb
{%- else %}
      - ejabberd: http://launchpadlibrarian.net/156862939/ejabberd_2.1.10-2ubuntu1.3_i386.deb
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

ejabberd_reg_user:
  file:
    - managed
    - name: /tmp/reg.sh
    - source: salt://ejabberd/reg.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 500
    - require:
      - service: ejabberd
  cmd:
    - wait
    - name: ./reg.sh
    - user: root
    - cwd: /tmp
    - watch:
      - file: ejabberd_reg_user