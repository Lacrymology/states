{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
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
