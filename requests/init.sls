{#
 Install Requests (HTTP library) into OS/root site-packages.
 #}
include:
  - pip

requests:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/requests-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://requests/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/requests-requirements.txt
    - watch:
      - file: requests
    - require:
      - module: pip
