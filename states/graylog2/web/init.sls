include:
  - ruby
  - nrpe
  - mongodb
  - nginx
  - cron
  - diamond
  - uwsgi
  - graylog2
{% if pillar['graylog2']['web']['ssl']|default(False) %}
  - ssl
{% endif %}

{% set web_root_dir = '/usr/local/graylog2-web-interface-' + pillar['graylog2']['web']['version'] %}

{% for filename in ('general', 'indexer', 'mongoid') %}
graylog2-web-{{ filename }}:
  file:
    - managed
    - name: {{ web_root_dir }}/config/{{ filename }}.yml
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graylog2/web/{{ filename }}.jinja2
{% endfor %}

{% for filename in ('config', 'email') %}
graylog2-web-{{ filename }}:
  file:
    - absent
    - name: {{ web_root_dir }}/config/{{ filename }}.yml
{% endfor %}

graylog2-web-config:
  file:
    - absent
    - name: {{ web_root_dir }}/config/config.yml

/etc/logrotate.d/graylog2-web:
  file:
    - absent

graylog2-web-upstart:
  file:
    - absent
    - name: /etc/init/graylog2-web.conf
  cmd:
    - wait
    - name: stop graylog2-web
    - watch:
      - file: graylog2-web-upstart

{{ web_root_dir }}/log:
  file:
    - symlink
    - force: True
    - target: /var/log/graylog2/

graylog2-web:
  gem:
    - installed
    - name: bundler
    - require:
      - pkg: ruby
    - watch:
      - archive: graylog2-web
  archive:
    - extracted
    - name: /usr/local/
    - source: http://download.graylog2.org/graylog2-web-interface/graylog2-web-interface-{{ pillar['graylog2']['web']['version'] }}.tar.gz
    - source_hash: {{ pillar['graylog2']['web']['checksum'] }}
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ web_root_dir }}
  cmd:
    - wait
    - stateful: False
    - name: bundle install
    - cwd: {{ web_root_dir }}
    - require:
      - gem: graylog2-web
    - watch:
      - archive: graylog2-web
  file:
    - managed
    - name: /etc/uwsgi/graylog2.ini
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 440
    - source: salt://graylog2/web/uwsgi.jinja2
    - context: {{ pillar['graylog2']['web'] }}
    - require:
      - file: {{ web_root_dir }}/log
      - service: uwsgi_emperor
      - service: mongodb
      - cmd: graylog2-web
  module:
    - wait
    - name: file.touch
    - m_name: /etc/uwsgi/graylog2.ini
    - require:
      - file: graylog2-web
    - watch:
      - archive: graylog2-web
{% for filename in ('general', 'indexer', 'mongoid') %}
      - file: graylog2-web-{{ filename }}
    - require:
      - file: /var/log/graylog2
{% endfor %}

graylog2_web_diamond_resource:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.graylog2]]
        cmdline = cmdline = ^graylog2-(worker|master)$

{% for command in ('streamalarms', 'subscriptions') %}
/etc/cron.hourly/graylog2-web-{{ command }}:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://graylog2/web/cron.jinja2
    - context:
      web_root_dir: {{ web_root_dir }}
      command: {{ command }}
    - require:
      - pkg: cron
{% endfor %}

/etc/nginx/conf.d/graylog2-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://graylog2/web/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - context: {{ pillar['graylog2']['web'] }}

/etc/nagios/nrpe.d/graylog2-web.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe_instance.jinja2
    - context:
      deployment: graylog2
      workers: {{ pillar['graylog2']['web']['workers'] }}
{% if 'cheaper' in pillar['graylog2']['web'] %}
      cheaper: {{ pillar['graylog2']['web']['cheaper'] }}
{% endif %}
      domain_name: {{ pillar['graylog2']['web']['hostnames'][0] }}
      uri: /login

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/graylog2-web.cfg
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/graylog2-web.conf
{% if pillar['graylog2']['web']['ssl']|default(False) %}
    {% for filename in ('server.key', 'server.crt', 'ca.crt') %}
        - file: /etc/ssl/{{ pillar['graylog2']['web']['ssl'] }}/{{ filename }}
    {% endfor %}
{% endif %}
