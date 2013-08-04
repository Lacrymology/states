{#
This state process SSL key self-signed or signed by a third party CA and make
them available or usable by the rest of these states.

Pillar data need to be in the following format:

ssl:
  [key_name]: [path to source of key in salt]
  [other_key_name]: [other path to source of key in salt]

such as:

ssl:
  example_com: salt://client_stuff/example/com/
  example_org: salt://client_stuff/example/org/

Requires files in source:
- ca.crt
  Bundled certificate
- server.crt
  Server certificate
- server.key
  Server private key
- server.csr
  Server Certificate Signing Request.
  A CSR or Certificate Signing request is a block of encrypted text that is
  generated on the server that the certificate will be used on. It contains
  information that will be included in your certificate such as your
  organization name, common name (domain name), locality, and country. It also
  contains the public key that will be included in your certificate. A private
  key is usually created at the same time that you create the CSR.
  How to generate a CSR (requires an existing key file):
    openssl req -new -keyout server.key -out server.csr
  How to generate a new CSR (no need for existing key file):
    openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
  How to decode a CSR:
    openssl req -in server.csr -noout -text

To use those SSL files in your states, you need to do the following:

- Add a pillar key for your state that hold the name of the SSL key name
  defined in pillar['ssl'], such as example_com in previous example.
  It can be:
    my_app:
      ssl: example_com
- If the daemon isn't running as root, add the group ssl-cert to the user with
  which that daemon run.
- Add ssl to the list of included sls file
- Requires the following three condition before starting your service:
    - cmd: /etc/ssl/{{ pillar['my_app']['ssl'] }}/chained_ca.crt
    - module: /etc/ssl/{{ pillar['my_app']['ssl'] }}/server.pem
    - file: /etc/ssl/{{ pillar['my_app']['ssl'] }}/ca.crt
- In the config file you point to the same path to reach those files, like:
    tls_cert = /etc/ssl/{{ pillar['my_app']['ssl'] }}/chained_ca.crt;
    tls_key = /etc/ssl/{{ pillar['my_app']['ssl'] }}/server.pem;
 #}

include:
  - apt

ssl-cert:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

{% for name in pillar['ssl'] %}

/etc/ssl/{{ name }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 775
    - require:
      - pkg: ssl-cert

{% for filename in ('server.key', 'server.crt', 'ca.crt') %}
{%- set pillar_key = filename.replace('.', '_') %}
/etc/ssl/{{ name }}/{{ filename }}:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name][pillar_key] | indent(8) }}
    - user: root
    - group: root
    - mode: 444
    - require:
      - file: /etc/ssl/{{ name }}
{% endfor %}

{#
Create from server private key and certificate a PEM used by most daemon
that support SSL.
#}
/etc/ssl/{{ name }}/server.pem:
  cmd:
    - wait
    - name: cat /etc/ssl/{{ name }}/server.crt /etc/ssl/{{ name }}/server.key > /etc/ssl/{{ name }}/server.pem
    - watch:
      - file: /etc/ssl/{{ name }}/server.crt
      - file: /etc/ssl/{{ name }}/server.key
  module:
    - wait
    - name: file.check_perms
    - m_name: /etc/ssl/{{ name }}/server.pem
    - ret: {}
    - mode: "440"
    - user: root
    - group: ssl-cert
    - require:
      - pkg: ssl-cert
    - watch:
      - cmd: /etc/ssl/{{ name }}/server.pem

{#
Some browsers may complain about a certificate signed by a well-known
certificate authority, while other browsers may accept the certificate without
issues. This occurs because the issuing authority has signed the server
certificate using an intermediate certificate that is not present in the
certificate base of well-known trusted certificate authorities which is
distributed with a particular browser. In this case the authority provides a
bundle of chained certificates which should be concatenated to the signed server
certificate. The server certificate must appear before the chained certificates
in the combined file:
#}
/etc/ssl/{{ name }}/chained_ca.crt:
  cmd:
    - wait
    - name: cat /etc/ssl/{{ name }}/server.crt /etc/ssl/{{ name }}/ca.crt > /etc/ssl/{{ name }}/chained_ca.crt
    - watch:
      - file: /etc/ssl/{{ name }}/server.crt
      - file: /etc/ssl/{{ name }}/ca.crt
{% endfor %}
