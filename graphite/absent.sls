{#
 Uninstall the web interface component of graphite
 #}

/etc/uwsgi/graphite.ini:
  file:
    - absent

{% for file in ('/var/log/graphite/graphite', '/etc/graphite/graphTemplates.conf', '/etc/nginx/conf.d/graphite.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/graphite.ini
{% endfor %}

{% for local in ('manage', 'salt-graphite-web-requirements.txt', 'bin/build-index.sh') %}
/usr/local/graphite/{{ local }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/graphite.ini
{% endfor %}

{% for module in ('wsgi.py', 'local_settings.py') %}
/usr/local/graphite/lib/python2.7/site-packages/graphite/{{ module }}:
  file:
    - absent
    - require:
      - file: /etc/uwsgi/graphite.ini
{% endfor %}
