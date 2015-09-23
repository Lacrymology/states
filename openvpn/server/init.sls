{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'openvpn/server/macro.jinja2' import service_openvpn with context -%}
{%- from 'macros.jinja2' import dict_default with context %}
include:
  - apt
  - openvpn
  - rsyslog
  - salt.minion.deps
  - openssl

/etc/default/openvpn:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/server/default.jinja2
    - require:
      - pkg: openvpn

{%- for type in ('lib', 'run', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770
{%- endfor -%}

{%- set ca_name = salt['pillar.get']('openvpn:ca:name') -%}
{%- set bits = salt['pillar.get']('openvpn:ca:bits') -%}
{%- set country = salt['pillar.get']('openvpn:ca:country') -%}
{%- set state = salt['pillar.get']('openvpn:ca:state') -%}
{%- set locality = salt['pillar.get']('openvpn:ca:locality') -%}
{%- set organization = salt['pillar.get']('openvpn:ca:organization') -%}
{%- set organizational_unit = salt['pillar.get']('openvpn:ca:organizational_unit') -%}
{%- set email = salt['pillar.get']('openvpn:ca:email') -%}
{%- set servers = salt['pillar.get']('openvpn:servers', {}) %}

openvpn_dh:
  cmd:
    - run
    - name: openssl dhparam -out /etc/openvpn/dh.pem {{ salt['pillar.get']('openvpn:dhparam:key_size', 2048) }}
    - unless: test -f /etc/openvpn/dh.pem
    - require:
      - pkg: openssl
      - pkg: openvpn

openvpn_ca:
  module:
    - run
    - name: tls.create_ca
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - ca_name: {{ ca_name }}
    - bits: {{ bits }}
    - days: {{ salt['pillar.get']('openvpn:ca:days') }}
    - CN: {{ salt['pillar.get']('openvpn:ca:common_name') }}
    - C: {{ country }}
    - ST: {{ state }}
    - L: {{ locality }}
    - O: {{ organization }}
    - OU: {{ organizational_unit }}
    - emailAddress: {{ email }}
    - unless: test -f /etc/openvpn/ca.crt
    - require:
      - pkg: salt_minion_deps
      - file: openvpn
  file:
    - managed
    - name: /etc/openvpn/ca.key
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - module: openvpn_ca

{%- for instance in servers -%}
    {%- set config_dir = '/etc/openvpn/' + instance -%}
    {%- set client_dir = config_dir ~ '/clients' %}
    {%- set mode = servers[instance]['mode'] %}
    {{ dict_default(servers[instance], 'clients', []) }}
    {{ dict_default(servers[instance], 'revocations', []) }}

{{ config_dir }}:
  file:
    - directory
    - user: nobody
    - group: nogroup
    - mode: 550
    - require:
      - pkg: openvpn

{{ config_dir }}/clients:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - file: {{ config_dir }}

openvpn_{{ instance }}_config:
  file:
    - managed
    - name: {{ config_dir }}/config
    - user: nobody
    - group: nogroup
    - source: salt://openvpn/server/{{ mode }}.jinja2
    - template: jinja
    - mode: 400
    - context:
        instance: {{ instance }}
    - watch_in:
      - service: openvpn-{{ instance }}
    - require:
      - file: {{ config_dir }}

    {%- if mode == 'static' %}
        {#- only 2 remotes are supported -#}
        {%- if servers[instance]['peers']|length == 2 %}

{{ instance }}_secret:
  file:
    - managed
    - name: {{ config_dir }}/secret.key
    - contents: |
        {{ servers[instance]['secret'] | indent(8) }}
    - user: nobody
    - group: nogroup
    - mode: 400
    - require:
      - file: {{ config_dir }}
    - watch_in:
      - service: openvpn-{{ instance }}

        {%- endif %}

{{ service_openvpn(instance) }}

openvpn_{{ instance }}_client:
  file:
    - managed
    - name: {{ config_dir }}/client.conf
    - user: nobody
    - group: nogroup
    - source: salt://openvpn/client/{{ mode }}.jinja2
    - template: jinja
    - mode: 400
    - context:
        instance: {{ instance }}
    - require:
      - file: {{ config_dir }}
  cmd:
    - wait
    - name: zip client.zip client.conf secret.key
    - cwd: {{ config_dir }}
    - watch:
      - file: openvpn_{{ instance }}_client
      - file: {{ instance }}_secret
    - require:
      - pkg: salt_minion_deps

{{ config_dir }}/client.zip:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - cmd: openvpn_{{ instance }}_client

    {%- elif servers[instance]['mode'] == 'tls' %}

openvpn_create_empty_crl_{{ instance }}:
  module:
    - run
    - name: tls.create_empty_crl
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - ca_name: {{ ca_name }}
    - crl_file: '/etc/openvpn/{{ instance }}/crl.pem'
    - unless: test -f /etc/openvpn/{{ instance }}/crl.pem
    - require:
      - module: openvpn_ca

openvpn_server_csr_{{ instance }}:
  module:
    - run
    - name: tls.create_csr
    - ca_name: {{ ca_name }}
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - cert_dir: '/etc/openvpn/{{ instance }}'
    - bits: {{ bits }}
    - CN: server
    - C: {{ country }}
    - ST: {{ state }}
    - L: {{ locality }}
    - O: {{ organization }}
    - OU: {{ organizational_unit }}
    - emailAddress: {{ email }}
    - unless: test -f /etc/openvpn/{{ instance }}/server.crt
    - require:
      - module: openvpn_ca

openvpn_server_cert_{{ instance }}:
  module:
    - wait
    - name: tls.create_ca_signed_cert
    - ca_name: {{ ca_name }}
    - CN: server
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - cert_dir: '/etc/openvpn/{{ instance }}'
    - extensions:
        basicConstraints:
          critical: False
          options: 'CA:FALSE'
        keyUsage:
          critical: False
          options: 'Digital Signature, Key Encipherment'
        extendedKeyUsage:
          critical: False
          options: 'serverAuth'
    - require:
      - file: /etc/openvpn/{{ instance }}
    - watch:
      - module: openvpn_server_csr_{{ instance }}
    - watch_in:
      - service: openvpn-{{ instance }}
  file:
    - managed
    - name: /etc/openvpn/{{ instance }}/server.key
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - module: openvpn_server_cert_{{ instance }}
    - require_in:
      - service: openvpn-{{ instance }}

{{ config_dir }}/ccd:
  file:
    - directory
    - user: nobody
    - group: nogroup
    - mode: 550
    - require:
      - file: {{ config_dir }}

{%- set server_octets = servers[instance]['server'].split()[0].split('.') %}
{%- set server_last_octet = server_octets[3]|int + 1 %}

        {%- for client in servers[instance]['clients'] -%}
            {%- if client not in servers[instance]['revocations'] -%}
                {%- if client is mapping -%}
                    {{ dict_default(servers[instance], 'topology', 'subnet') }}
                    {%- set topology = servers[instance]['topology'] %}
                    {%- set client, client_ip = servers[instance]['clients'][loop.index0].items()[0] %}

{{ config_dir }}/ccd/{{ client }}:
  file:
    - managed
    - user: nobody
    - group: nogroup
    - mode: 400
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}

                    {%- if topology == "subnet" %}
        ifconfig-push {{ client_ip }} {{ servers[instance]['server'].split()[1] }}
                    {%- elif topology == "net30" %}
                        {%- set client_octets = client_ip.split('.') -%}
                        {%- set server_last_octet = client_octets[3]|int + 1 %}
        ifconfig-push {{ client_ip }} {{ client_octets[0] + "." + client_octets[1] + "." + client_octets[2] + "." + server_last_octet|string }}
                    {%- endif %}
    - require:
      - file: {{ config_dir }}/ccd
    - watch_in:
      - service: openvpn-{{ instance }}
                {%- endif %}

openvpn_client_csr_{{ instance }}_{{ client }}:
  module:
    - run
    - name: tls.create_csr
    - ca_name: {{ ca_name }}
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - cert_dir: '/etc/openvpn/{{ instance }}/clients'
    - bits: {{ bits }}
    - CN: {{ client }}
    - C: {{ country }}
    - ST: {{ state }}
    - L: {{ locality }}
    - O: {{ organization }}
    - OU: {{ organizational_unit }}
    - emailAddress: {{ email }}
    - unless: test -f /etc/openvpn/{{ instance }}/clients/{{ client }}.crt
    - require:
      - module: openvpn_ca
      - file: {{ config_dir }}/clients

openvpn_client_cert_{{ instance }}_{{ client }}:
  module:
    - wait
    - name: tls.create_ca_signed_cert
    - ca_name: {{ ca_name }}
    - CN: {{ client }}
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - cert_dir: '/etc/openvpn/{{ instance }}/clients'
    - extensions:
        basicConstraints:
          critical: False
          options: 'CA:FALSE'
        keyUsage:
          critical: False
          options: 'Digital Signature'
        extendedKeyUsage:
          critical: False
          options: 'clientAuth'
    - require:
      - file: {{ config_dir }}/clients
    - watch:
      - module: openvpn_client_csr_{{ instance }}_{{ client }}
  file:
    - managed
    - name: /etc/openvpn/{{ instance }}/clients/{{ client }}.key
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - module: openvpn_client_cert_{{ instance }}_{{ client }}

openvpn_{{ instance }}_{{ client }}:
  file:
    - managed
    - name: {{ config_dir }}/clients/{{ client }}.conf
    - user: root
    - group: root
    - source: salt://openvpn/client/{{ servers[instance]['mode'] }}.jinja2
    - template: jinja
    - mode: 400
    - context:
        instance: {{ instance }}
        client: {{ client }}
    - require:
      - file: {{ config_dir }}
                {%- if not salt['file.file_exists'](config_dir + '/clients/' + client + '.zip') %}
  cmd:
    - wait
    - name: zip -j {{ client }}.zip {{ client }}.conf {{ client }}.crt {{ client }}.key /etc/openvpn/ca.crt
    - cwd: {{ config_dir }}/clients
    - watch:
      - file: openvpn_{{ instance }}_{{ client }}
      - module: openvpn_ca
      - module: openvpn_client_cert_{{ instance }}_{{ client }}
    - require:
      - pkg: salt_minion_deps

{{ config_dir }}/clients/{{ client }}.zip:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - cmd: openvpn_{{ instance }}_{{ client }}
                {%- endif -%}
            {%- endif %}{# client cert not in revocation list -#}
        {%- endfor %}{# client cert -#}

        {#- Revoke clients certificate -#}
        {%- for r_client in servers[instance]['revocations'] %}
openvpn_revoke_client_cert_{{ r_client }}:
  module:
    - run
    - name: tls.revoke_cert
    - ca_name: {{ ca_name }}
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - CN: {{ r_client }}
    - cert_dir: '/etc/openvpn/{{ instance }}/clients'
    - crl_file: '{{ config_dir }}/crl.pem'
    - require:
      - pkg: salt_minion_deps
      - module: openvpn_create_empty_crl_{{ instance }}
    - watch_in:
      - service: openvpn-{{ instance }}
        {%- endfor -%}

{%- call service_openvpn(instance) %}
      - cmd: openvpn_dh
      - file: openvpn_{{ instance }}_config
      - module: openvpn_ca
      - module: openvpn_create_empty_crl_{{ instance }}
      - module: openvpn_server_cert_{{ instance }}
      - file: /etc/default/openvpn
{%- endcall -%}
    {%- endif %}{# tls -#}
{%- endfor -%}
