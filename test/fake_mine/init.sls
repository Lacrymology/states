{#-
 Fake the mine module, this let a minion to run without a master.
 -#}

fake_mine:
  file:
    - managed
    - name: /root/salt/states/_modules/mine.py
    - source: salt://test/fake_mine/mine.py
    - user: root
    - group: root
    - mode: 755
