{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "strongswan/map.jinja2" import strongswan with context %}

include:
  - apt
  - strongswan
  - sysctl

{%- set ca_name = salt['pillar.get']('strongswan:ca:name') -%}
{%- set bits = salt['pillar.get']('strongswan:ca:bits', 2048) -%}
{%- set country = salt['pillar.get']('strongswan:ca:country') -%}
{%- set state = salt['pillar.get']('strongswan:ca:state') -%}
{%- set locality = salt['pillar.get']('strongswan:ca:locality') -%}
{%- set organization = salt['pillar.get']('strongswan:ca:organization') -%}
{%- set organizational_unit = salt['pillar.get']('strongswan:ca:organizational_unit') -%}
{%- set email = salt['pillar.get']('strongswan:ca:email') %}

strongswan_ca_key:
  cmd:
    - run
    - cwd: /etc/ipsec.d/private
    - name: ipsec pki --gen --size {{ bits }} --outform pem > {{ ca_name}}_key.pem
    - unless: test -f /etc/ipsec.d/private/{{ ca_name }}_key.pem
    - require:
      - pkg: strongswan
  file:
    - managed
    - name: /etc/ipsec.d/private/{{ ca_name }}_key.pem
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - cmd: strongswan_ca_key

strongswan_ca_cert:
  cmd:
    - run
    - cwd: /etc/ipsec.d/cacerts
    - name: ipsec pki --self --in /etc/ipsec.d/private/{{ ca_name }}_key.pem --dn "C={{ country }}, ST={{ state }}, L={{ locality }}, O={{ organization }}, OU={{ organizational_unit }}, CN={{ ca_name }} CA, E={{ email }}" --ca --outform pem > {{ ca_name }}_cert.pem
    - unless: test -f /etc/ipsec.d/cacerts/{{ ca_name }}_cert.pem
    - require:
      - cmd: strongswan_ca_key
  module:
    - wait
    - name: cmd.run
    - cwd: /etc/ipsec.d/cacerts
    - cmd: openssl x509 -in {{ ca_name }}_cert.pem -inform pem -out {{ ca_name }}_cert.der -outform der
    - unless: test -f /etc/ipsec.d/cacerts/{{ ca_name }}_cert.der
    - watch:
      - cmd: strongswan_ca_cert

strongswan_server_key:
  cmd:
    - run
    - cwd: /etc/ipsec.d/private
    - name: ipsec pki --gen --size {{ bits }} --outform pem > server_key.pem
    - unless: test -f /etc/ipsec.d/private/server_key.pem
    - require:
      - pkg: strongswan
  file:
    - managed
    - name: /etc/ipsec.d/private/server.key
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - cmd: strongswan_server_key

{%- set default_interface = salt['pillar.get']('network_interface', 'eth0') %}
{%- set strongswan_interface = salt['pillar.get']('strongswan:public_interface', False)|default(default_interface, boolean=True) %}

strongswan_server_cert:
  cmd:
    - run
    - cwd: /etc/ipsec.d/certs
    - name: ipsec pki --pub --in /etc/ipsec.d/private/server_key.pem | ipsec pki --issue --cacert /etc/ipsec.d/cacerts/{{ ca_name }}_cert.pem --cakey /etc/ipsec.d/private/{{ ca_name }}_key.pem --dn "C={{ country }}, ST= {{ state }}, L={{ locality }}, O={{ organization }}, OU={{ organizational_unit }}, CN=server, E={{ email }}" --san {{ grains['ip_interfaces'][strongswan_interface][0] }} --flag serverAuth --flag ikeIntermediate --outform pem > server_cert.pem
    - unless: test -f /etc/ipsec.d/certs/server.der
    - require:
      - cmd: strongswan_ca_key
      - cmd: strongswan_ca_cert
      - cmd: strongswan_server_key

{%- for client, password in salt['pillar.get']('strongswan:clients', {}).iteritems() %}
strongswan_client_{{ client }}_key:
  cmd:
    - run
    - cwd: /etc/ipsec.d/private
    - name: ipsec pki --gen --size {{ bits }} --outform pem > {{ client }}_key.pem
    - unless: test -f /etc/ipsec.d/private/{{ client }}_key.pem
    - require:
      - pkg: strongswan
  file:
    - managed
    - name: /etc/ipsec.d/private/{{ client }}_key.pem
    - user: root
    - group: root
    - mode: 400
    - replace: False
    - require:
      - cmd: strongswan_client_{{ client }}_key

strongswan_client_{{ client }}_cert:
  cmd:
    - run
    - cwd: /etc/ipsec.d/certs
    - name: ipsec pki --pub --in /etc/ipsec.d/private/{{ client }}_key.pem | ipsec pki --issue --cacert /etc/ipsec.d/cacerts/{{ ca_name }}_cert.pem --cakey /etc/ipsec.d/private/{{ ca_name }}_key.pem --dn "C={{ country }}, ST= {{ state }}, L={{ locality }}, O={{ organization }}, OU={{ organizational_unit }}, CN={{ client }}, E={{ email }}" --san {{ grains['ip_interfaces'][strongswan_interface][0] }} --outform pem > {{ client }}_cert.pem
    - unless: test -f /etc/ipsec.d/certs/{{ client }}_cert.pem
    - require:
      - cmd: strongswan_ca_key
      - cmd: strongswan_ca_cert
      - cmd: strongswan_client_{{ client }}_key
  module:
    - wait
    - name: cmd.run
    - cwd: /etc/ipsec.d/certs
    - cmd: openssl pkcs12 -export -inkey /etc/ipsec.d/private/{{ client }}_key.pem -in {{ client }}_cert.pem -name "{{ client }}" -certfile /etc/ipsec.d/cacerts/{{ ca_name }}_cert.pem -caname "{{ ca_name }} CA" -out {{ client }}_cert.p12 -password pass:{{ password }}
    - unless: test -f /etc/ipsec.d/certs/{{ client }}_cert.p12
    - watch:
      - cmd: strongswan_client_{{ client }}_cert
{%- endfor %}

/etc/ipsec.secrets:
  file:
    - managed
    - source: salt://strongswan/server/ipsec_secrets.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 400
    - require:
      - pkg: strongswan

{{ strongswan.config_file }}:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}

        {{ strongswan.ike_daemon }} {
    {%- for dns in salt['pillar.get']('strongswan:dns_servers', ['8.8.8.8', '8.8.4.4']) %}
            dns{{ loop.index }} = {{ dns }}
    {%- endfor %}
        }
    - require:
      - pkg: strongswan

/etc/ipsec.conf:
  file:
    - managed
    - source: salt://strongswan/server/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: strongswan

extend:
  strongswan:
    service:
      - running
      - name: {{ strongswan.starter_name }}
      - watch:
        - file: /etc/ipsec.conf
        - file: /etc/ipsec.secrets
        - file: {{ strongswan.config_file }}
        - cmd: strongswan_server_key
        - cmd: strongswan_server_cert
        {#- ip_forward must be enabled #}
        - file: sysctl
  iptables:
    file:
      - source: salt://strongswan/server/firewall.jinja2
