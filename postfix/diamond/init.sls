{#
 Diamond statistics for postfix
#}

include:
  - diamond
postfix_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/PostfixCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postfix/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors

postfix_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[postfix]]
        exe = ^\/usr\/lib\/postfix\/master$

postfix_stats:
  file:
    - managed
    - name: /usr/local/diamond/postfix-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://postfix/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/postfix-requirements.txt
    - require:
      - virtualenv: diamond
    - watch:
      - file: postfix_stats

extend:
  diamond:
    service:
      - watch:
        - file: postfix_diamond_collector
        - module: postfix_stats
