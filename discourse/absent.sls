{#-
Copyright (C) 2013 the Institute for Institutional Innovation by Data
Driven Design Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE  MASSACHUSETTS INSTITUTE OF
TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the names of the Institute for
Institutional Innovation by Data Driven Design Inc. shall not be used in
advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from the
Institute for Institutional Innovation by Data Driven Design Inc.

Author: Lam Dang Tung <lamdt@familug.org>
Maintainer: Lam Dang Tung <lamdt@familug.org>

Uninstall Discourse.
-#}

{%- set version = "0.9.6.3" %}
{%- set web_root_dir = "/usr/local/discourse-" + version %}

discourse:
  user:
    - absent
    - force: True
  group:
    - absent
    - require:
      - user: discourse
  service:
    - dead

{%- for file in (web_root_dir, '/home/discourse', '/etc/nginx/conf.d/discourse.conf', '/etc/logrotate.d/discourse', '/etc/init/discourse.conf') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: discourse
{%- endfor %}

uwsgi_discourse:
  uwsgi:
    - absent
    - name: discourse

discourse-upstart-log:
  cmd:
    - run
    - name: find /var/log/upstart/ -maxdepth 1 -type f -name 'discourse.log.*' -delete
    - require:
      - service: discourse
