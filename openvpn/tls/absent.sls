{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
{%- set servers = salt['pillar.get']('openvpn:servers', {}) %}
{%- set openvpn_available = salt['service.available']('openvpn') %}

{%- for instance in servers %}
    {%- if servers[instance]['mode'] == 'tls' %}
openvpn_{{ instance }}:
        {%- if openvpn_available %}
  cmd:
    - run
    - name: service openvpn stop {{ instance }}
        {%- endif %}
  file:
    - absent
    - name: /etc/openvpn/{{ instance }}
        {%- if openvpn_available %}
    - require:
      - cmd: openvpn_{{ instance }}
        {%- endif %}

/etc/openvpn/{{ instance }}.conf:
  file:
    - absent
        {%- if openvpn_available %}
    - require:
      - cmd: openvpn_{{ instance }}
        {%- endif %}
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
