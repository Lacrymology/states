{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'openvpn/macro.jinja2' import service_openvpn with context %}

include:
  - apt
  - rsyslog
  - salt.minion.deps
  - ssl

openvpn:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  module:
    - wait
    - name: service.stop
    - m_name: openvpn
    - watch:
      - pkg: openvpn
  cmd:
    - wait
    - name: update-rc.d -f openvpn remove
    - watch:
      - module: openvpn
  file:
    - absent
    - name: /etc/init.d/openvpn
    - watch:
      - cmd: openvpn

/etc/default/openvpn:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/default.jinja2
    - require:
      - pkg: openvpn

{%- for type in ('lib', 'run', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770
{% endfor %}

{%- set ca_name = salt['pillar.get']('openvpn:ca:name') %}
{%- set bits = salt['pillar.get']('openvpn:ca:bits') %}
{%- set days = salt['pillar.get']('openvpn:ca:days') %}
{%- set common_name = salt['pillar.get']('openvpn:ca:common_name') %}
{%- set country = salt['pillar.get']('openvpn:ca:country') %}
{%- set state = salt['pillar.get']('openvpn:ca:state') %}
{%- set locality = salt['pillar.get']('openvpn:ca:locality') %}
{%- set organization = salt['pillar.get']('openvpn:ca:organization') %}
{%- set organizational_unit = salt['pillar.get']('openvpn:ca:organizational_unit') %}
{%- set email = salt['pillar.get']('openvpn:ca:email') %}

openvpn_dh:
  cmd:
    - wait
    - name: openssl dhparam -out /etc/openvpn/dh.pem {{ salt['pillar.get']('openvpn:dhparam:key_size', 2048) }}
    - watch:
      - pkg: ssl-cert
      - pkg: openvpn

openvpn_ca:
  module:
    - run
    - name: tls.create_ca
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - ca_name: {{ ca_name }}
    - bits: {{ bits }}
    - days: {{ days }}
    - CN: {{ common_name }}
    - C: {{ country }}
    - ST: {{ state }}
    - L: {{ locality }}
    - O: {{ organization }}
    - OU: {{ organizational_unit }}
    - emailAddress: {{ email }}
    - require:
      - pkg: salt_minion_deps
      - file: openvpn
  file:
    - managed
    - name: /etc/openvpn/ca.key
    - user: root
    - group: root
    - mode: 400
    - require:
      - module: openvpn_ca

{%- set servers = salt['pillar.get']('openvpn:servers', {}) %}

{%- if salt['pkg.version_cmp'](pkg1=salt['pkg.version']('salt-minion'), pkg2='2015.2.0') == -1 %}
    {%- set archive_function_name = 'archive.zip' %}
{%- else %}
    {%- set archive_function_name = 'archive.cmd_zip' %}
{%- endif %}

{%- for instance in servers -%}
{%- set config_dir = '/etc/openvpn/' + instance -%}
{%- set client_dir = config_dir ~ '/clients' %}
{%- set mode = servers[instance]['mode'] %}
{%- set clients = servers[instance]['clients'] | default([]) %}
{%- set crls = servers[instance]['revocations'] | default([]) %}

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
    - user: nobody
    - group: nogroup
    - mode: 550
    - require:
      - file: {{ config_dir }}

openvpn_{{ instance }}_config:
  file:
    - managed
    - name: {{ config_dir }}/config
    - user: nobody
    - group: nogroup
    - source: salt://openvpn/{{ mode }}.jinja2
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
  module:
    - wait
    - name: {{ archive_function_name }}
    - zipfile: {{ config_dir }}/client.zip
    - cwd: {{ config_dir }}
    - sources:
      - {{ config_dir }}/client.conf
      - {{ config_dir }}/secret.key
    - watch:
      - file: openvpn_{{ instance }}_client
      - file: {{ instance }}_secret
    - require:
      - pkg: salt_minion_deps

    {%- elif servers[instance]['mode'] == 'tls' %}

openvpn_server_csr_{{ instance }}:
  module:
    - wait
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
    - watch:
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
    - require:
      - module: openvpn_server_cert_{{ instance }}

        {%- if clients is iterable and clients | length > 0 %}
            {%- for client in clients %}
                {%- if crls is not iterable or (crls is iterable and client not in crls) %}
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
    - require:
      - module: openvpn_client_cert_{{ instance }}_{{ client }}

openvpn_{{ instance }}_{{ client }}:
  file:
    - managed
    - name: {{ config_dir }}/clients/{{ client }}.conf
    - user: nobody
    - group: nogroup
    - source: salt://openvpn/client/{{ mode }}.jinja2
    - template: jinja
    - mode: 400
    - context:
        instance: {{ instance }}
        client: {{ client }}
    - require:
      - file: {{ config_dir }}
  module:
    - wait
    - name: {{ archive_function_name }}
    - zipfile: {{ config_dir }}/clients/{{ client }}.zip
    - cwd: {{ config_dir }}
    - sources:
      - {{ client_dir }}/{{ client }}.conf
      - /etc/openvpn/ca.crt
      - {{ client_dir }}/{{ client }}.crt
      - {{ client_dir }}/{{ client }}.key
    - watch:
      - file: openvpn_{{ instance }}_{{ client }}
      - module: openvpn_ca
      - module: openvpn_client_cert_{{ instance }}_{{ client }}
    - require:
      - pkg: salt_minion_deps
                {%- endif %} {# client cert not in revocation list #}
            {%- endfor %} {# client cert #}
        {%- endif %} {# there is at least one client #}

        {%- if crls is iterable and crls | length > 0 %}
            {%- for r_client in crls %}
openvpn_revoke_client_cert_{{ r_client }}:
  module:
    - run
    - name: tls.revoke_cert
    - ca_name: {{ ca_name }}
    - ca_dir: '/etc/openvpn'
    - ca_filename: 'ca'
    - CN: {{ r_client }}
    - cert_dir: '/etc/openvpn/{{ instance }}/clients'
    - crl_path: {{ config_dir }}/crl.pem
    - require:
      - pkg: salt_minion_deps
    - watch_in:
      - service: openvpn-{{ instance }}
  cmd:
    - wait
    - name: rm -f /etc/openvpn/{{ instance }}/clients/{{ r_client }}*
    - watch:
      - module: openvpn_revoke_client_cert_{{ r_client }}
            {%- endfor %}

openvpn_{{ instance }}_config_append:
  cmd:
    - wait
    - name: echo "crl-verify {{ config_dir }}/crl.pem" >> {{ config_dir }}/config
    - onlyif: test -s {{ config_dir }}/crl.pem
    - unless: grep ^crl-verify {{ config_dir }}/config
    - require:
      - file: openvpn_{{ instance }}_config
            {%- for r_client in crls %}
    - watch:
      - module: openvpn_revoke_client_cert_{{ r_client }}
            {%- endfor %}
    - watch_in:
      - service: openvpn-{{ instance }}

        {%- endif %} {# revocation #}

{% call service_openvpn(instance) %}
      - cmd: openvpn_dh
      - file: openvpn_{{ instance }}_config
      - module: openvpn_ca
      - module: openvpn_server_cert_{{ instance }}
      - file: /etc/default/openvpn
{% endcall %}
    {%- endif %} {# tls #}

{%- endfor %}
