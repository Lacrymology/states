{%- set result_file = '/root/salt/result.xml' -%}

test_result:
  file:
    - rename
    - name: {{ result_file }}
    - source: {{ salt['file.find']('/root/salt/', name='TEST-*-salt.xml')[0] }}
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
    - path: /root/salt/{{ type }}.log
    - require:
      - cmd: {{ type }}
{%- endfor %}
