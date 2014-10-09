{%- if grains['virtual'] == 'VirtualBox' -%}
include:
  - kernel.dev
  - fs

virtualbox-guest:
  pkg:
    - installed
    - name: virtualbox-guest-dkms
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

{%- else %}
include:
  - virtual.guest.absent
{%- endif -%}
