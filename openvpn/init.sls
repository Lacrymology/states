{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
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

{%- for type in ('lib', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770
{% endfor %}

{%- set ca_name = salt['pillar.get']('openvpn:ca:name') %}
{%- set key_size = salt['pillar.get']('openvpn:dhparam:key_size', 2048) %}

openvpn_dh:
  cmd:
    - run
    - name: openssl dhparam -out /etc/openvpn/dh{{ key_size }}.pem {{ key_size }}
    - unless: test -f /etc/openvpn/dh{{ key_size }}.pem
    - require:
      - pkg: ssl-cert
      - pkg: openvpn

{#-
`tls._ca_exists` does not work as expected:

  Function tls._ca_exists is not available

so, using `file.file_exists` as a workaround
#}
{%- set ca_exists = salt['file.file_exists']('/etc/pki/' ~ ca_name ~ '/' ~ ca_name ~ '_ca_cert.crt') %}
{% if not ca_exists %}
openvpn_ca:
  module:
    - run
    - name: tls.create_ca
    - ca_name: {{ ca_name }}
    - bits: {{ salt['pillar.get']('openvpn:ca:bits') }}
    - days: {{ salt['pillar.get']('openvpn:ca:days') }}
    - CN: {{ salt['pillar.get']('openvpn:ca:common_name') }}
    - C: {{ salt['pillar.get']('openvpn:ca:country') }}
    - ST: {{ salt['pillar.get']('openvpn:ca:state') }}
    - L: {{ salt['pillar.get']('openvpn:ca:locality') }}
    - O: {{ salt['pillar.get']('openvpn:ca:organization') }}
    - OU: {{ salt['pillar.get']('openvpn:ca:organizational_unit') }}
    - emailAddress: {{ salt['pillar.get']('openvpn:ca:email') }}
    - require:
      - pkg: salt_minion_deps
  file:
    - copy
    - name: /etc/openvpn/ca.crt
    - source: /etc/pki/{{ ca_name }}/{{ ca_name }}_ca_cert.crt
    - require:
      - module: openvpn_ca
{%- endif %}

{%- set servers = salt['pillar.get']('openvpn:servers', {}) %}

{%- for instance in servers -%}
{%- set config_dir = '/etc/openvpn/' + instance -%}
{%- set mode = servers[instance]['mode'] %}

{{ config_dir }}:
  file:
    - directory
    - user: nobody
    - group: nogroup
    - mode: 550
    - require:
      - pkg: openvpn

{{ config_dir }}/config:
  file:
    - managed
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

{{ instance }}-secret:
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

    {%- elif servers[instance]['mode'] == 'tls'-%}

        {%- if not ca_exists %}
openvpn_server_csr_{{ instance }}:
  module:
    - wait
    - name: tls.create_csr
    - ca_name: {{ ca_name }}
    - CN: server_{{ instance }}
    - watch:
      - module: openvpn_ca

openvpn_server_cert_{{ instance }}:
  module:
    - wait
    - name: tls.create_ca_signed_cert
    - ca_name: {{ ca_name }}
    - CN: server_{{ instance }}
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
    - watch:
      - module: openvpn_server_csr_{{ instance }}
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/server.crt
    - source: /etc/pki/{{ ca_name }}/certs/server_{{ instance }}.crt
    - require:
      - module: openvpn_server_cert_{{ instance }}
      - file: {{ config_dir }}
    - watch_in:
      - service: openvpn-{{ instance }}

openvpn_server_key_{{ instance }}:
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/server.key
    - source: /etc/pki/{{ ca_name }}/certs/server_{{ instance }}.key
    - require:
      - module: openvpn_server_cert_{{ instance }}
      - file: /etc/openvpn/{{ instance }}
    - watch_in:
      - service: openvpn-{{ instance }}

openvpn_server_key_{{ instance }}_chmod:
  file:
    - managed
    - name: /etc/openvpn/{{ instance }}/server.key
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: openvpn_server_key_{{ instance }}

            {%- for client in servers[instance]['clients'] %}
openvpn_client_csr_{{ instance }}_{{ client }}:
  module:
    - wait
    - name: tls.create_csr
    - ca_name: {{ ca_name }}
    - CN: {{ instance }}_{{ client }}
    - watch:
      - module: openvpn_ca

openvpn_client_cert_{{ instance }}_{{ client }}:
  module:
    - wait
    - name: tls.create_ca_signed_cert
    - ca_name: {{ ca_name }}
    - CN: {{ instance }}_{{ client }}
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
    - watch:
      - module: openvpn_client_csr_{{ instance }}_{{ client }}
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/{{ instance }}_{{ client }}.crt
    - source: /etc/pki/{{ ca_name }}/certs/{{ instance }}_{{ client }}.crt
    - require:
      - module: openvpn_client_cert_{{ instance }}_{{ client }}
      - file: {{ config_dir }}

openvpn_client_key_{{ instance }}_{{ client }}:
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/{{ instance }}_{{ client }}.key
    - source: /etc/pki/{{ ca_name }}/certs/{{ instance }}_{{ client }}.key
    - require:
      - module: openvpn_client_cert_{{ instance }}_{{ client }}
      - file: {{ config_dir }}
            {%- endfor %}
        {%- endif %}

{% call service_openvpn(instance) %}
      - cmd: openvpn_dh
    {%- if not ca_exists %}
      - file: openvpn_ca
      - file: openvpn_server_cert_{{ instance }}
      - file: openvpn_server_key_{{ instance }}_chmod
    {%- endif %}
      - file: /etc/default/openvpn
{% endcall %}
    {%- endif %}
{%- endfor %}
