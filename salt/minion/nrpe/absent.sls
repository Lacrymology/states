{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
/usr/lib/nagios/plugins/check_minion_last_success.py:
  file:
    - absent

sudo_salt_minion_nrpe:
  file:
    - absent
    - name: /etc/sudoers.d/salt_minion_nrpe

/usr/lib/nagios/plugins/check_minion_pillar_render.py:
  file:
    - absent

salt_minion_pillar_render_data_collector:
  file:
    - name: /etc/cron.twice_daily/salt_minion_pillar
    - absent

{{ passive_absent('salt.minion') }}
