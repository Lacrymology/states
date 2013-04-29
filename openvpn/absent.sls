{#
 Uninstall and OpenVPN servers
 #}

openvpn:
  pkg:
    - purged

/etc/default/openvpn:
  file:
    - absent
    - require:
      - pkg: openvpn

{% for type in ('lib', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - absent
{% endfor %}
