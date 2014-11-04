{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>

This state process SSL key self-signed or signed by a third party CA and make
them available or usable by the rest of these states.
-#}

include:
  - apt

ssl-cert:
  pkg:
    - latest
    - require:
      - cmd: apt_sources

{% for name in salt['pillar.get']('ssl', []) -%}
/etc/ssl/{{ name }}:
  file:
    - absent

/etc/ssl/private/{{ name }}.key:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name]['server_key'] | indent(8) }}
    - user: root
    - group: ssl-cert
    - mode: 440
    - require:
      - pkg: ssl-cert

/etc/ssl/certs/{{ name }}.crt:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name]['server_crt'] | indent(8) }}
    - user: root
    - group: ssl-cert
    - mode: 444
    - require:
      - pkg: ssl-cert

/etc/ssl/certs/{{ name }}_ca.crt:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name]['ca_crt'] | indent(8) }}
    - user: root
    - group: ssl-cert
    - mode: 444
    - require:
      - pkg: ssl-cert

{#-
Create from server private key and certificate a PEM used by most daemon
that support SSL.
#}
/etc/ssl/private/{{ name }}.pem:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name]['server_crt'] | indent(8) }}
        {{ pillar['ssl'][name]['server_key'] | indent(8) }}
    - user: root
    - group: ssl-cert
    - mode: 440
    - require:
      - pkg: ssl-cert

{#- This is for ejabberd #}
/etc/ssl/private/{{ name }}_bundle.pem:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name]['server_crt'] | indent(8) }}
        {{ pillar['ssl'][name]['server_key'] | indent(8) }}
        {{ pillar['ssl'][name]['ca_crt'] | indent(8) }}
    - user: root
    - group: ssl-cert
    - mode: 440
    - require:
      - pkg: ssl-cert

{#-
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
/etc/ssl/certs/{{ name }}_chained.crt:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name]['server_crt'] | indent(8) }}
        {{ pillar['ssl'][name]['ca_crt'] | indent(8) }}
    - user: root
    - group: ssl-cert
    - mode: 444
    - require:
      - pkg: ssl-cert

{#- as service need to watch all cert files, use this cmd as trigger that
    service restart everywhen cert files changed #}
ssl_cert_and_key_for_{{ name }}:
  cmd:
    - wait
    - name: echo managed ssl cert for {{ name }}
    - watch:
      - file: /etc/ssl/private/{{ name }}.key
      - file: /etc/ssl/certs/{{ name }}.crt
      - file: /etc/ssl/certs/{{ name }}_ca.crt
      - file: /etc/ssl/private/{{ name }}.pem
      - file: /etc/ssl/certs/{{ name }}_chained.crt
      - file: /etc/ssl/private/{{ name }}_bundle.pem

{#- OpenSSL expects to find each certificate in a file named by the certificate
    subject's hashed name, plus a number extension that starts with 0.

    That means you can't just drop My_Awesome_CA_Cert.pem in the directory and
    expect it to be picked up automatically. However, OpenSSL ships with 
    a utility called c_rehash which you can invoke on a directory 
    to have all certificates indexed with appropriately named symlinks. 
    
    http://mislav.uniqpath.com/2013/07/ruby-openssl/#SSL_CERT_DIR #}
ssl_create_symlink_by_hash_for_{{ name }}:
  cmd:
    - wait
    - name: c_rehash /etc/ssl/certs
    - watch:
      - file: /etc/ssl/certs/{{ name }}.crt
      - file: /etc/ssl/certs/{{ name }}_ca.crt
      - file: /etc/ssl/certs/{{ name }}_chained.crt
{% endfor -%}
