{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
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
