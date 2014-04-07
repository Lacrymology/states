{%- macro manage_upstart_log(software) %}
{{ software }}_upstart_rsyslog_config:
  file:
    - managed
    - mode: 440
    - source: salt://rsyslog/template.jinja2
    - name: /etc/rsyslog.d/{{ software }}-upstart.conf
    - template: jinja
    - require:
      - pkg: rsyslog
    - watch_in:
      - service: rsyslog
    - context:
      file_path: /var/log/upstart/{{ software }}.log
      tag_name: {{ software }}-upstart
      severity: error
      facility: daemon
{%- endmacro %}
