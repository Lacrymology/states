{#-
Copyright (c) 2013, Hung Nguyen Viet
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>

Install python-pip, a cache for downloaded archive and a config file
to force root user to use the cache folder.
-#}
include:
  - apt
  - git
  - local
  - mercurial
  - python
  - ssh.client

{% set root_user_home = salt['user.info']('root')['home'] %}

{{ root_user_home }}/.pip:
  file:
    - directory
    - user: root
    - group: root
    - mode: 700

{%- if 'files_archive' in pillar %}
/var/cache/pip:
  file:
    - absent
{%- else %}
/var/cache/pip:
  file:
    - directory
    - user: root
    - group: root
    - mode: 700
{%- endif %}

pip-config:
  file:
    - managed
    - name: {{ root_user_home }}/.pip/pip.conf
    - template: jinja
    - source: salt://pip/config.jinja2
    - user: root
    - group: root
    - require:
      - file: {{ root_user_home }}/.pip
      - file: /var/cache/pip

python-pip:
  pkg:
    - purged

python-setuptools:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

{{ opts['cachedir'] }}/pip:
  file:
    - directory
    - user: root
    - group: root
    - mode: 550

{%- set version='1.5.2' -%}

{#- TODO: remove that statement in >= 2014-04 #}
{{ opts['cachedir'] }}/pip-1.3.1: {#- leave the old version there #}
  file:
    - absent

pip:
  file:
    - directory
    - name: /usr/local/lib/python{{ grains['pythonversion'][0] }}.{{ grains['pythonversion'][1] }}/dist-packages
    - makedirs: True
  archive:
    - extracted
    - name: {{ opts['cachedir'] }}/pip
{%- if 'files_archive' in pillar %}
    - source: {{ pillar['files_archive'] }}/pip/pip-{{ version }}.tar.gz
{%- else %}
    - source: https://pypi.python.org/packages/source/p/pip/pip-{{ version }}.tar.gz
{%- endif %}
    - source_hash: md5=5da30919f732d68b1c666e484e7676f5
    - archive_format: tar
    - tar_options: z
    - if_missing: {{ opts['cachedir'] }}/pip/pip-{{ version }}
    - require:
      - file: /usr/local
      - file: {{ opts['cachedir'] }}/pip
  module:
{%- if not salt['file.file_exists']('/usr/local/bin/pip') -%}
    {#- force module to run if pip isn't installed yet #}
    - run
{%- else %}
    - wait
    - watch:
      - archive: pip
{%- endif %}
    - name: cmd.run
    - cmd: /usr/bin/python setup.py install
    - cwd: {{ opts['cachedir'] }}/pip/pip-{{ version }}
    - require:
      - pkg: python-pip
      - file: pip-config
      - pkg: python
      - pkg: python-setuptools
      - file: pip
{%- if not salt['file.file_exists']('/usr/local/bin/pip') %}
      - archive: pip
{%- endif %}
{#-
 Upgrade distribute to avoid the following error:
 $ pip freeze
 Warning: cannot find svn location for distribute==0.6.24dev-r0
 [snip]
 ## FIXME: could not find svn URL in dependency_links for this package:
 distribute==0.6.24dev-r0
 [snip]
distribute:
  module:
    - wait
    - name: pip.install
    - pkgs: distribute
    - upgrade: True
    - watch:
      - module: pip
-#}
