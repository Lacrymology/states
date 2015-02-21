{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{#-
  Can't uninstall the following as they're used elsewhere
ruby:
  pkg:
    - purged
    - pkgs:
      - ruby1.8
      - rubygems
      - rake
      - ruby-dev
      - libreadline5
      - libruby1.8
      - ruby1.8-dev
      - ruby1.9.3
      - ruby1.9.1-dev
      - ruby1.9.1
#}

/.gem:
  file:
    - absent

/var/lib/gems:
  file:
    - absent
