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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Openvpn:
  my_tunnel:
    secret: |
      -----BEGIN OpenVPN Static key V1-----
      e7bc198038df066bedbfe31c91480937
      c4918f2cbb1d03cb39c66cff2418d4a6
      86bbf3749f7e11fc763cb5b846359734
      9bef811cb013ed5ecee9cff9c9306057
      b092b732e18d1787f79c3b00902ca24b
      64b39bb7c5b562a61e4b0ac85413140d
      6158ec9dceeeb74e92800f9e72eeaaef
      76b9299a82177cb6e287c1a5c45e3ff8
      12972d66c5d47e0dd44a0237d202cb6a
      457028239249b664e0cb29f3d135c885
      63542981489942783eb09f4366f5443a
      38c23e0b5212ce82caa33348c5e9064b
      dad1b2d96543ac0f50641796606e35f0
      6f54484d4943766bb400465919682d00
      5dd915d308b89c327dfc6b8fe8fd1561
      9de72bc3bafbca8936a120a24018000c
      -----END OpenVPN Static key V1-----
    peers:
      minion-1:
        address: 192.168.1.1
        vpn_address: 10.0.0.1
        port: 1234
      minion-2:
        address: 192.168.1.2
        vpn_address: 10.0.0.2
        port: 1234
To generate a secret key::
  openvpn --genkey --secret /dev/stdout
-#}
{%- from 'openvpn/init.sls' import service_openvpn -%}

include:
  - openvpn

{%- for tunnel in salt['pillar.get']('openvpn', {}) -%}
    {%- set config_dir = '/etc/openvpn/' + tunnel -%}
    {#- only 2 remotes are supported -#}
    {%- if salt['pillar.get']('openvpn', {})[tunnel]['peers']|length == 2 %}
{{ config_dir }}:
  file:
    - directory
    - user: nobody
    - group: nogroup
    - mode: 550
    - require:
      - pkg: openvpn

{{ tunnel }}-secret:
  file:
    - managed
    - name: {{ config_dir }}/secret.key
    - contents: |
        {{ salt['pillar.get']('openvpn', {})[tunnel]['secret'] | indent(8) }}
    - user: nobody
    - group: nogroup
    - mode: 400
    - require:
      - file: {{ config_dir }}
    - watch_in:
      - service: openvpn-{{ tunnel }}

{{ config_dir }}/config:
  file:
    - managed
    - user: nobody
    - group: nogroup
    - source: salt://openvpn/static/config.jinja2
    - template: jinja
    - mode: 400
    - context:
      tunnel: {{ tunnel }}
    - watch_in:
      - service: openvpn-{{ tunnel }}
    - require:
      - file: {{ config_dir }}
    {%- endif -%}
{%- endfor -%}

{{ service_openvpn(salt['pillar.get']('openvpn', {})) }}
