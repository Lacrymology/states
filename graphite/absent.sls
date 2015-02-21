{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

graphite-web:
  file:
    - absent
    - name: /etc/uwsgi/graphite.yml

{% for file in ('/var/log/graphite/graphite', '/etc/graphite/graphTemplates.conf', '/etc/nginx/conf.d/graphite.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - file: graphite-web
{% endfor %}

{% for local in ('manage', 'salt-graphite-requirements.txt', 'bin/build-index.sh') %}
/usr/local/graphite/{{ local }}:
  file:
    - absent
    - require:
      - file: graphite-web
{% endfor %}

{% for module in ('wsgi.py', 'local_settings.py') %}
/usr/local/graphite/lib/python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}/site-packages/graphite/{{ module }}:
  file:
    - absent
    - require:
      - file: graphite-web
{% endfor %}
