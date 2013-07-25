{#-
 Copy files archive if necessary.
 -#}

include:
  - deborphan
  - test.sync

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
    {# password: root #}
    - password: $6$FAsR0aKa$JoJGdUhaFGY1YxNEBDc8CEJig4L2GpAuAD8mP9UHhjViiJxJC2BTm9vFceEFDbB/yru5dEzLGHAssXthWNvON.

upgrade_pkg:
  module:
    - wait
    - name: pkg.upgrade
    - refresh: True
    - require:
      - module: sync_all
    - watch:
      - user: root
