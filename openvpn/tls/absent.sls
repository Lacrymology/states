{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
{%- set servers = salt['pillar.get']('openvpn:servers', {}) %}

{%- for instance in servers %}
    {%- if servers[instance]['mode'] == 'tls' %}
openvpn_{{ instance }}:
  cmd:
    - run
    - name: service openvpn stop {{ instance }}
    - onlyif: test -x /etc/init.d/openvpn
  file:
    - absent
    - name: /etc/openvpn/{{ instance }}
    - require:
      - cmd: openvpn_{{ instance }}

/etc/openvpn/{{ instance }}.conf:
  file:
    - absent
    - require:
      - cmd: openvpn_{{ instance }}
    {%- endif %}
{%- endfor %}

{%- for file in ('ca.crt', 'dh' ~ salt['pillar.get']('openvpn:dhparam:key_size', 2048) ~ '.pem') %}
/etc/openvpn/{{ file }}:
  file:
    - absent
{%- endfor %}

/etc/pki/{{ salt['pillar.get']('openvpn:ca:name') }}:
  file:
    - absent
