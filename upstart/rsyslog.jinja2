{%- macro manage_upstart_log(service) %}
{{ service }}_upstart_rsyslog_config:
  file:
    - managed
    - mode: 440
    - source: salt://rsyslog/template.jinja2
    - name: /etc/rsyslog.d/{{ service }}-upstart.conf
    - template: jinja
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
    - context:
      file_path: /var/log/upstart/{{ service }}.log
      tag_name: {{ service }}-upstart
      severity: error
      facility: daemon
{%- endmacro %}
