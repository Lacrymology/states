{#
 Uninstall uWSGI Web app server.
 #}

uwsgitop:
  pip:
    - uninstalled

uwsgi:
  service:
    - dead
    - enable: False

{% for file in ('/etc/uwsgi', '/etc/init/uwsgi.conf', '/var/lib/uwsgi', '/usr/local/uwsgi') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: uwsgi
{% endfor %}
