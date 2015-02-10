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
    - wait
    - name: tls.create_ca
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
    - watch:
      - pkg: salt_minion_deps
  file:
    - copy
    - name: /etc/openvpn/ca.crt
    - source: /etc/pki/{{ ca_name }}/{{ ca_name }}_ca_cert.crt
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
{%- set mode = servers[instance]['mode'] %}
{%- set crls = servers[instance]['revocations'] | default([]) %}

{{ config_dir }}:
  file:
    - directory
    - user: nobody
    - group: nogroup
    - mode: 550
    - require:
      - pkg: openvpn

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
    - bits: {{ bits }}
    - CN: {{ instance }}_server
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
    - CN: {{ instance }}_server
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
    - source: /etc/pki/{{ ca_name }}/certs/{{ instance }}_server.crt
    - require:
      - module: openvpn_server_cert_{{ instance }}
      - file: {{ config_dir }}
    - watch_in:
      - service: openvpn-{{ instance }}

openvpn_server_key_{{ instance }}:
  file:
    - copy
    - name: /etc/openvpn/{{ instance }}/server.key
    - source: /etc/pki/{{ ca_name }}/certs/{{ instance }}_server.key
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
            {%- if client not in crls %}
openvpn_client_csr_{{ instance }}_{{ client }}:
  module:
    - run
    - name: tls.create_csr
    - ca_name: {{ ca_name }}
    - bits: {{ bits }}
    - CN: {{ instance }}_{{ client }}
    - C: {{ country }}
    - ST: {{ state }}
    - L: {{ locality }}
    - O: {{ organization }}
    - OU: {{ organizational_unit }}
    - emailAddress: {{ email }}
    - require:
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

openvpn_{{ instance }}_{{ client }}:
  file:
    - managed
    - name: {{ config_dir }}/{{ instance }}_{{ client }}.conf
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
    - zipfile: {{ config_dir }}/{{ client }}.zip
    - cwd: {{ config_dir }}
    - sources:
      - {{ config_dir }}/{{ instance }}_{{ client }}.conf
      - /etc/openvpn/ca.crt
      - {{ config_dir }}/{{ instance }}_{{ client }}.crt
      - {{ config_dir }}/{{ instance }}_{{ client }}.key
    - watch:
      - file: openvpn_{{ instance }}_{{ client }}
      - file: openvpn_ca
      - file: openvpn_client_cert_{{ instance }}_{{ client }}
      - file: openvpn_client_key_{{ instance }}_{{ client }}
    - require:
      - pkg: salt_minion_deps
            {%- endif %} {# client cert not in revocation list #}

        {%- endfor %} {# client cert #}

        {%- if crls %}
            {%- set crl_exists = salt['file.file_exists'](config_dir ~ '/crl.pem') %}
            {%- for r_client in crls %}
openvpn_revoke_client_cert_{{ r_client }}:
  module:
    - run
    - name: tls.revoke_cert
    - ca_name: {{ ca_name }}
    - CN: {{ instance }}_{{ r_client }}
    - crl_path: {{ config_dir }}/crl.pem
    - require:
      - pkg: salt_minion_deps
                {%- if crl_exists %}
    - require_in:
      - file: openvpn_{{ instance }}_config_append
                {%- endif %}

                {%- for file in ( ('/etc/pki/' ~ ca_name ~ '/certs/' ~ instance ~ '_' ~ r_client ~ '.csr',
                                   '/etc/pki/' ~ ca_name ~ '/certs/' ~ instance ~ '_' ~ r_client ~ '.crt',
                                   '/etc/pki/' ~ ca_name ~ '/certs/' ~ instance ~ '_' ~ r_client ~ '.key',
                                   '/etc/openvpn/' ~ instance ~ '/' ~ instance ~ '_' ~ r_client ~ '.conf',
                                   '/etc/openvpn/' ~ instance ~ '/' ~ r_client ~ '.zip') ) %}
{{ file }}:
  file:
    - absent
    - require:
      - module: openvpn_revoke_client_cert_{{ r_client }}
                {%- endfor %}
            {%- endfor %}

            {%- if crl_exists %}
openvpn_{{ instance }}_config_append:
  file:
    - append
    - name: {{ config_dir }}/config
    - text: |
        crl-verify {{ config_dir }}/crl.pem
    - require:
      - file: openvpn_{{ instance }}_config
    - watch_in:
      - service: openvpn-{{ instance }}
            {%- endif %}
        {%- endif %} {# revocation #}

{% call service_openvpn(instance) %}
      - cmd: openvpn_dh
      - file: openvpn_{{ instance }}_config
      - file: openvpn_ca
      - file: openvpn_server_cert_{{ instance }}
      - file: openvpn_server_key_{{ instance }}_chmod
      - file: /etc/default/openvpn
{% endcall %}
    {%- endif %} {# tls #}

{%- endfor %}
