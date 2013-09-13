{%- set result_file = '/root/salt/result.xml' -%}
{%- set test_files = salt['file.find']('/root/salt/', name='TEST-*-salt.xml') %}

test_result:
  file:
{%- test_files -%}
    {#- integration.py worked #}
    - rename
    - source: {{ test_files[0] }}
{%- else -%}
    {#- integration.py failed #}
    - managed
    - source: salt://test/jenkins/result/failure.xml
{%- endif %}
    - name: {{ result_file }}
  module:
    - run
    - name: cp.push
    - path: {{ result_file }}
    - require:
      - file: test_result

{%- for type in ('stdout', 'stderr') %}
{{ type }}:
  cmd:
    - run
    - name: xz /root/salt/{{ type }}.log
  module:
    - run
    - name: cp.push
    - path: /root/salt/{{ type }}.log.xz
    - require:
      - cmd: {{ type }}
{%- endfor %}
