{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set crons = ('twice_daily', 'daily', 'weekly', 'monthly') -%}
{%- macro test_cron() -%}
    {%- for suffix in crons -%}
        {%- if loop.last -%}
            {#- the last loop iteration is called test_crons to make it easier
                to requires it. #}
test_crons:
        {%- else %}
test_cron_{{ suffix }}:
        {% endif %}
  cmd:
    - run
    - name: run-parts --report /etc/cron.{{ suffix }}
    - onlyif: test -d /etc/cron.{{ suffix }}
        {%- if caller is defined -%}
            {%- for line in caller().split("\n") -%}
                {%- if loop.first %}
    - require:
                {%- endif %}
{{ line|trim|indent(6, indentfirst=True) }}
            {%- endfor -%}
        {%- endif -%}
        {%- if not loop.first -%}
            {#- run-parts requires the previous one, loop.index counts from 1, list index counts from 0 #}
      - cmd: test_cron_{{ crons[loop.index - 2] }}
        {%- endif -%}
    {%- endfor -%}
{%- endmacro %}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - cron
  - cron.diamond
  - cron.nrpe
  - doc

test:
  monitoring:
    - run_all_checks
    - order: last
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('cron') }}
  qa:
    - test
    - name: cron
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
