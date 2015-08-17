{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

piwik:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/apt/sources.list.d/piwik.list
  cmd:
    - run
    - name: apt-key del 66FED89E
    - onlyif: apt-key list | grep -q 66FED89E

{% for file in ("/etc/uwsgi/piwik.yml",
                "/etc/nginx/conf.d/piwik.conf",
                "/usr/local/piwik",
                opts["cachedir"] ~ "/pip/piwik",
                "/etc/piwik",
                "/etc/cron.daily/piwik-geoip",) %}
{{ file }}:
  file:
    - absent
{%- endfor %}
