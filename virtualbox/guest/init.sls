{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- if grains['virtual'] == 'VirtualBox' -%}
include:
  - kernel.image.dev
  - kernel.modules

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
