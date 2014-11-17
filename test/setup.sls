{#-
Copyright (c) 2013, Bruno Clermont
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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Copy files archive if necessary.
-#}

include:
  - deborphan

{#-
 Fake the mine module, this let a minion to run without a master.
#}

fake_mine:
  file:
    - managed
    - name: /root/salt/states/_modules/mine.py
    - user: root
    - group: root
    - mode: 755
    - contents: |
        def get(*args):
            minion_id = __salt__['grains.item']('id')['id']
            return {minion_id: __salt__['monitoring.data']()}

sync_all:
  module:
    - run
    - name: saltutil.sync_all
    - require:
      - file: fake_mine

{%- set root_info = salt['user.info']('root') -%}

{#-
 You can't uninstall sudo, if no root password
#}
root:
  user:
    - present
    - shell: {{ root_info['shell'] }}
    - home: {{ root_info['home'] }}
    - uid: {{ root_info['uid'] }}
    - gid: {{ root_info['gid'] }}
    - enforce_password: True
    {# password: gZu4s7DMAsmIQRGb #}
    - password: $6$xzxRRSbJsoq/JPVg$T5ZIMb.4kiKfjoio2328oJWZyEbCRi.YJ6gTRmx8rhBnY8fAFkdl5FXglu5tqqlCSRdRCFhbzZqQAjjAmaD/H/

upgrade_pkg:
  module:
    - wait
    - name: pkg.upgrade
    - refresh: True
    - require:
      - module: sync_all
    - watch:
      - user: root

{%- for hostname in salt['common.unique_hostname'](pillar) %}
    {%- if hostname|replace('.', '')|int == 0 %}
hostname-{{ hostname }}:
  host:
    - present
    - name: {{ hostname }}
    - ip: 127.0.0.1
    {% endif %}
{%- endfor %}
