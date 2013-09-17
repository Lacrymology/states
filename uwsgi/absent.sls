{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Uninstall uWSGI Web app server.
 -#}

uwsgi_emperor:
  service:
    - dead
    - name: uwsgi

{% for file in ('/etc/uwsgi', '/etc/init/uwsgi.conf', '/var/lib/uwsgi', '/usr/local/uwsgi') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: uwsgi
{% endfor %}

apt-key del 67E15F46:
  cmd:
    - run
    - onlyif: apt-key list | grep -q 67E15F46
