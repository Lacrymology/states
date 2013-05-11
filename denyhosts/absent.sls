{#
 Uninstall Denyhosts used to block SSH brute-force attack
 #}
denyhosts:
  pkg:
    - purged
    - require:
      - service: denyhosts
  file:
    - absent
    - name: /etc/denyhosts.conf
    - require:
      - service: denyhosts
  service:
    - dead
    - enable: False

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts', '/var/lib/denyhosts') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}
