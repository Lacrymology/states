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

/etc/uwsgi/piwik.yml:
  file:
    - absent

/etc/nginx/conf.d/piwik.conf:
  file:
    - absent

/usr/local/piwik:
  file:
    - absent

{{ opts['cachedir'] }}/pip/piwik:
  file:
    - absent
