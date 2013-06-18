{#
 Uninstall uWSGI Web app server.
 #}

uwsgi:
  service:
    - dead

{% for file in ('/etc/uwsgi', '/etc/init/uwsgi.conf', '/var/lib/uwsgi', '/usr/local/uwsgi') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: uwsgi
{% endfor %}
