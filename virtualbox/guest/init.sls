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
