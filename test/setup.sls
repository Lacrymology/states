{#- Usage of this is governed by a license that can be found in doc/license.rst
-*- ci-automatic-discovery: off -*-

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

{#-
clear cache to make sure salt load fake mine module
#}
clear_minion_cache:
  module:
    - run
    - name: saltutil.clear_cache
    - require:
      - file: fake_mine

sync_all:
  module:
    - run
    - name: saltutil.sync_all
    - require:
      - module: clear_minion_cache

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
