libreoffice:
  pkg:
    - purged
  file:
    - name: /etc/apt/sources.list.d/ppa.launchpad.net-libreoffice_libreoffice-4-0_ubuntu-precise.list
    - absent

{% for i in ('bigbluebutton', 'bbb-config', 'bbb-web', 'bbb-openoffice-headless', 'red5', 'bbb-record-core', 'bbb-freeswitch', 'bbb-apps', 'bbb-client', 'bbb-apps-sip', 'bbb-common', 'bbb-playback-presentation', 'bbb-apps-deskshare', 'bbb-apps-video') %}
{{ i }}:
  pkg:
    - purged
    - require_in:
      - pkg: ruby1.9.2
{% endfor %}

libffi5:
  pkg:
    - purged
    - require:
      - pkg: ruby1.9.2

ruby1.9.2:
  pkg:
    - purged

{% for i in ('ruby', 'ri', 'irb', 'erb', 'rdoc', 'gem') %}
/usr/bin/{{ i }}:
  file:
    - absent
{% endfor %}

/etc/apt/sources.list.d/bigbluebutton.list:
  file:
    - absent

/usr/local/bin/bbb-conf-wrap.sh:
  file:
    - absent
