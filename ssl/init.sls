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

{%- for name in salt['pillar.get']('ssl', []) -%}
/etc/ssl/{{ name }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 775
    - require:
      - pkg: ssl-cert

    {%- for filename in ('server.key', 'server.crt', 'ca.crt') -%}
        {%- set pillar_key = filename.replace('.', '_') %}
/etc/ssl/{{ name }}/{{ filename }}:
  file:
    - managed
    - contents: |
        {{ pillar['ssl'][name][pillar_key] | indent(8) }}
    - user: root
    - group: ssl-cert
    - mode: 440
    - require:
      - pkg: ssl-cert
      - file: /etc/ssl/{{ name }}
    {%- endfor -%}

{#-
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
/etc/ssl/{{ name }}/chained_ca.crt:
  cmd:
    - wait
    - name: cat /etc/ssl/{{ name }}/server.crt /etc/ssl/{{ name }}/ca.crt > /etc/ssl/{{ name }}/chained_ca.crt
    - watch:
      - file: /etc/ssl/{{ name }}/server.crt
      - file: /etc/ssl/{{ name }}/ca.crt
{%- endfor -%}
