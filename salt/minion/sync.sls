salt-minion-sync:
  module:
    - run
    - name: saltutil.sync_all
