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
