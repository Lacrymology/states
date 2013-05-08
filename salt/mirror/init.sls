include:
  - reprepro
  - nginx
{% if pillar['salt_ppa_mirror']['ssl']|default(False) %}
  - ssl
{% endif %}

/var/lib/reprepro/salt:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - /var/lib/reprepro

/var/lib/reprepro/salt/ubuntu:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - /var/lib/reprepro/salt

{% set filenames = ('distributions', 'updates') %}
{% for version in pillar['salt_ppa_mirror']['versions'] %}
{% set root="/var/lib/reprepro/salt/ubuntu/" + version + "/" %}
{{ root }}:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - file: /var/lib/reprepro/salt/ubuntu

{{ root }}/conf:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - file: {{ root }}

{% for filename in filenames %}
{{ root }}/conf/{{ filename }}:
  file:
    - managed
    - template: jinja
    - source: salt://salt/mirror/{{ filename }}.jinja2
    - user: root
    - group: www-data
    - mode: 640
    - require:
      - file: {{ root }}/conf
{% endfor %}

{% for distribution in pillar['salt_ppa_mirror']['distributions'] %}
reprepro-update-{{ version }}-{{ distribution }}:
  cmd:
    - wait
    - name: reprepro update {{ distribution }}
    - cwd: {{ root }}
    - watch:
      - file: {{ root }}
    - require:
{% for filename in filenames %}
      - file: {{ root }}/conf/{{ filename }}
{% endfor %}
{% endfor %}{# distributions #}
{% endfor %}{# versions #}

/etc/nginx/conf.d/salt_mirror_ppa.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/mirror/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/salt_mirror_ppa.conf
{% if pillar['salt_ppa_mirror']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['salt_ppa_mirror']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['salt_ppa_mirror']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['salt_ppa_mirror']['ssl'] }}/ca.crt
{% endif %}
