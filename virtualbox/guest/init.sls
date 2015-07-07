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
    - require:
      - pkg: kernel-headers
    - require_in:
      - cmd: kernel_modules
  service:
    - running
    - name: virtualbox-guest-utils
    - require:
      - file: kernel_modules

{%- else %}
include:
  - virtualbox.guest.absent
{%- endif -%}
