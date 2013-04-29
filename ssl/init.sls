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
  RapidSSL bundled certificate
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
  How to decode a CSR:
    openssl req -in server.csr -noout -text
 #}

{# ssl-certs debian package use ssl-cert group to easily give access to
   private key on some process #}
ssl-cert:
  group:
    - present
    - system: True

{% for name in pillar['ssl'] %}

/etc/ssl/{{ name }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 775

{% for filename in ('server.key', 'server.crt', 'ca.crt') %}
/etc/ssl/{{ name }}/{{ filename }}:
  file:
    - managed
    - source: {{ pillar['ssl'][name] }}/{{ filename }}
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
      - group: ssl-cert
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
