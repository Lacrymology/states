libreoffice:
  pkg:
    - purged
  file:
    - name: /etc/apt/sources.list.d/ppa.launchpad.net-libreoffice_libreoffice-4-0_ubuntu-precise.list
    - absent

libffi5:
  pkg:
    - purged
    - require:
      - pkg: ruby1.9.2

libreadline5:
  pkg:
    - purged

ruby1.9.2:
  pkg:
    - purged

{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
/usr/bin/{{ i }}:
  file:
    - absent
{% endfor %}

bigbluebutton:
  pkgrepo:
    - purged

/etc/apt/sources.list.d/bigbluebutton.list:
  file:
    - absent
