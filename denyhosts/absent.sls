{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts', '/var/lib/denyhosts', '/usr/local/bin/denyhosts-unblock') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}

hostsdeny_empty_contents:
  cmd:
    - run
    - name: cat /dev/null > /etc/hosts.deny
    - require:
      - service: denyhosts
