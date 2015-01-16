{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


Shinken reactionner state.

The reactionner daemon issues notifications and launches event_handlers. This
centralizes communication channels with external systems in order to simplify
SMTP authorizations or RSS feed sources (only one for all hosts/services).
There can be many reactionners for load-balancing and spare roles
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
{% set ssl = salt['pillar.get']('shinken:ssl', False) %}
include:
  - rsyslog
  - shinken
{% if ssl %}
  - ssl
{% endif %}

shinken-reactionner:
  file:
    - managed
    - name: /etc/init/shinken-reactionner.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
        shinken_component: reactionner
  service:
    - running
    - enable: True
    - order: 50
    - require:
      - file: /var/lib/shinken
      - file: /var/run/shinken
    - watch:
      - cmd: shinken
      - file: /etc/shinken/reactionner.conf
      - user: shinken
      - file: shinken-reactionner
{% if ssl %}
      - cmd: ssl_cert_and_key_for_{{ ssl }}
{% endif %}
{#- does not use PID, no need to manage #}

{{ manage_upstart_log('shinken-reactionner') }}

/etc/shinken/reactionner.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/config.jinja2
    - context:
        shinken_component: reactionner
    - require:
      - virtualenv: shinken
      - user: shinken
      - file: /etc/shinken
