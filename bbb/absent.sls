{#-
Copyright (c) 2013, Hung Nguyen Viet

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>
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
    - name: pkill -9 -f '/usr/bin/soffice' || true
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
