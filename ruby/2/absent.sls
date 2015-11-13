{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

ruby2:
  pkg:
    - purged
    - pkgs:
      - ruby2.1
      - ruby2.1-dev
      - libruby2.1
      - rubygems-integration
  file:
    - absent
    - name: /etc/apt/sources.list.d/ruby-2.list
  cmd:
    - run
    - name: apt-key del C3173AA6
    - onlyif: apt-key list | grep -q C3173AA6
