apt-key del 0E27C0A6:
  cmd:
    - run
    - onlyif: apt-key list | grep -q 0E27C0A6

salt:
  file:
    - absent
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_release'] }}.list
