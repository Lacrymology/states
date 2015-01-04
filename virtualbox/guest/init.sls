{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- if grains['virtual'] == 'VirtualBox' -%}
include:
  - kernel.dev

virtualbox-guest:
  pkg:
    - installed
    - pkgs:
      - virtualbox-guest-utils
      - virtualbox-guest-dkms
    - required:
      - pkg: kernel-headers
  kmod:
    - present
    - name: vboxsf
    - persist: True
    - require:
      - pkg: virtualbox-guest
  service:
    - running
    - name: virtualbox-guest-utils
    - require:
      - kmod: virtualbox-guest


{%- else %}
include:
  - virtualbox.guest.absent
{%- endif -%}
