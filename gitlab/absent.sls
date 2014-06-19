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

Unistalling GitLab.
-#}
{%- set version = '6.4.3' %}
{%- set web_dir = "/usr/local/gitlabhq-" + version  %}
{%- set user = 'gitlab' %}

gitlab:
  user:
    - absent
    - name: {{ user }}
    - force: True
    - require:
      - uwsgi: gitlab
      - service: gitlab
  group:
    - absent
    - name: {{ user }}
    - require:
      - user: gitlab
  uwsgi:
    - absent
    - name: gitlab
  service:
    - dead

{%- for file in ('/etc/nginx/conf.d/gitlab.conf', web_dir, '/home/' + user, '/etc/init/gitlab.conf', '/etc/logrotate.d/gitlab') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: gitlab
{%- endfor %}

gitlab-upstart-log:
  cmd:
    - run
    - name: find /var/log/upstart/ -maxdepth 1 -type f -name 'gitlab.log*' -delete
    - require:
      - service: gitlab

/etc/rsyslog.d/gitlab-upstart.conf:
  file:
    - absent
