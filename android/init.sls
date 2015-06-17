include:
  - gradle
{#TODO: choose java version base on what project use #}
  - java.7.jdk
  - local

android_sdk:
  pkg:
    - installed
    - pkgs:
      - libncurses5:i386
      - libstdc++6:i386
      - zlib1g:i386
    - require:
      - cmd: apt_sources
  archive:
    - extracted
    - name: /usr/local/
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/android-sdk_r24.3.2-linux.tgz
{%- else %}
    - source: http://dl.google.com/android/android-sdk_r24.3.2-linux.tgz
{%- endif %}
    - source_hash: sha1=4a10e62c5d88fd6c2a69db12348cbe168228b98f
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/local/android-sdk-linux
    - require:
      - file: /usr/local
  file:
    - append
    - name: /etc/environment
    - text: |
        export ANDROID_HOME="/usr/local/android-sdk-linux"
    - require:
      - archive: android_sdk
      - pkg: android_sdk

{# TODO: find a way to auto choosing target base on version #}
android_sdk_buildtools:
  cmd:
    - run
    - name: echo -e "y\n" | $ANDROID_HOME/tools/android update sdk -u -a -t 7 # 21.1.2
    - require:
      - file: android_sdk

android_sdk_platform_api:
  cmd:
    - run
    - name: echo -e "y\n" | $ANDROID_HOME/tools/android update sdk -u -a -t 26 #  SDK Platform Android 5.0.1, API 21
    - require:
      - file: android_sdk
