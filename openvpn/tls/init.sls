{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
{%- set ca_name = salt['pillar.get']('openvpn:ca:name') %}
{%- set key_size = salt['pillar.get']('openvpn:dhparam:key_size', 2048) %}

include:
  - apt
  - openssl
  - openvpn

openvpn_dh:
  cmd:
    - run
    - name: openssl dhparam -out /etc/openvpn/dh{{ key_size }}.pem {{ key_size }}
    - unless: test -f /etc/openvpn/dh{{ key_size }}.pem
    - require:
      - pkg: openssl
      - pkg: openvpn

{#-
`tls._ca_exists` does not work as expected:

  Function tls._ca_exists is not available

so, using `file.file_exists` as a workaround
#}
{%- set ca_exists = salt['file.file_exists']('/etc/pki/' ~ ca_name ~ '/' ~ ca_name ~ '_ca_cert.crt') %}
{%- if not ca_exists %}
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
  file:
    - copy
    - name: /etc/openvpn/ca.crt
    - source: /etc/pki/{{ ca_name }}/{{ ca_name }}_ca_cert.crt
    - require:
      - module: openvpn_ca
{%- endif %}

{%- set servers = salt['pillar.get']('openvpn:servers', {}) %}
{%- for instance in servers %}
    {%- if servers[instance]['mode'] == 'tls' %}
/etc/openvpn/{{ instance }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550
    - require:
      - pkg: openvpn

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
      - file: /etc/openvpn/{{ instance }}

openvpn_server_key_{{ instance }}:
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/server.key
    - source: /etc/pki/{{ ca_name }}/certs/server_{{ instance }}.key
    - require:
      - module: openvpn_server_cert_{{ instance }}
      - file: /etc/openvpn/{{ instance }}

openvpn_server_key_{{ instance }}_chmod:
  file:
    - managed
    - name: /etc/openvpn/{{ instance }}/server.key
    - user: root
    - group: root
    - mode: 400
    - require:
      - file: openvpn_server_key_{{ instance }}

openvpn_client_csr_{{ instance }}:
  module:
    - wait
    - name: tls.create_csr
    - ca_name: {{ ca_name }}
    - CN: client_{{ instance }}
    - watch:
      - module: openvpn_ca

openvpn_client_cert_{{ instance }}:
  module:
    - wait
    - name: tls.create_ca_signed_cert
    - ca_name: {{ ca_name }}
    - CN: client_{{ instance }}
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
      - module: openvpn_client_csr_{{ instance }}
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/client.crt
    - source: /etc/pki/{{ ca_name }}/certs/client_{{ instance }}.crt
    - require:
      - module: openvpn_server_cert_{{ instance }}
      - file: /etc/openvpn/{{ instance }}

openvpn_client_key_{{ instance }}:
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/client.key
    - source: /etc/pki/{{ ca_name }}/certs/client_{{ instance }}.key
    - require:
      - module: openvpn_client_cert_{{ instance }}
      - file: /etc/openvpn/{{ instance }}
        {%- endif %}

/etc/openvpn/{{ instance }}.conf:
  file:
    - managed
    - source: salt://openvpn/tls/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        instance: {{ instance }}
    - require:
      - pkg: openvpn

restart_openvpn_{{ instance }}:
  cmd:
    - wait
    - name: service openvpn restart {{ instance }}
    - require:
      - file: /var/lib/openvpn
    - watch:
      - cmd: openvpn_dh
        {%- if not ca_exists %}
      - file: openvpn_ca
      - file: openvpn_server_cert_{{ instance }}
      - file: openvpn_server_key_{{ instance }}_chmod
        {%- endif %}
      - file: /etc/openvpn/{{ instance }}.conf
      - file: /etc/default/openvpn
    {%- endif %}
{%- endfor %}
