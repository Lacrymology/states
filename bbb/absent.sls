{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
libreoffice:
  file:
    - absent
    - name: /etc/apt/sources.list.d/ppa.launchpad.net-libreoffice_libreoffice-4-0_ubuntu-precise.list
  cmd:
    - run
    - name: 'apt-key del 1378B444'
    - onlyif: apt-key list | grep -q 1378B444

kill_soffice:
  cmd:
    - run
    - name: killall -9 /usr/bin/soffice || true
  file:
    - absent
    - name: /var/run/bbb-openoffice-server.pid
    - require:
      - cmd: kill_soffice

bigbluebutton:
  pkg:
    - purged
    - pkgs:
      - bigbluebutton
      - bbb-config
      - bbb-web
      - bbb-openoffice-headless
      - red5
      - bbb-record-core
      - bbb-freeswitch
      - bbb-apps
      - bbb-client
      - bbb-apps-sip
      - bbb-common
      - bbb-playback-presentation
      - bbb-apps-deskshare
      - bbb-apps-video
      - libffi5
      - ruby1.9.2
      - libreoffice
    - require:
      - file: kill_soffice

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

{%- set bbb_dir = opts['cachedir'] + "/bbb" -%}
redis_build_dir:
  file:
    - absent
    - name: {{ bbb_dir }}
