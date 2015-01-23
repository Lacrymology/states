{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
{%- for instance in salt['pillar.get']('openvpn:servers') %}
openvpn_{{ instance }}:
  cmd:
    - run
    - name: service openvpn stop {{ instance }}
  file:
    - absent
    - name: /etc/openvpn/{{ instance }}
    - require:
      - cmd: openvpn_{{ instance }}

/etc/openvpn/{{ instance}}.conf:
  file:
    - absent
    - require:
      - cmd: openvpn_{{ instance }}
{%- endfor %}

{%- for file in ('ca.crt', 'dh' ~ salt['pillar.get']('openvpn:dhparam:key_size', 2048) ~ '.pem') %}
/etc/openvpn/{{ file }}:
  file:
    - absent
{%- endfor %}
