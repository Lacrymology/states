include:
  - local
  - salt.minion.deps
  - java.7.jdk

gradle_archive:
  archive:
    - extracted
    - name: /usr/local/
{%- set files_archive = salt['pillar.get']('files_archive', False) %}
{%- if files_archive %}
    - source: {{ files_archive }}/mirror/gradle-2.4-bin.zip
{%- else %}
    - source: https://services.gradle.org/distributions/gradle-2.4-bin.zip
{%- endif %}
    - source_hash: md5=2e8ca4d4e9f86f2c11762efd96b61aaf
    - archive_format: zip
    - if_missing: /usr/local/gradle-2.4
    - require:
      - file: /usr/local
      - pkg: salt_minion_deps
  file:
    - symlink
    - name: /usr/local/bin/gradle
    - target: /usr/local/gradle-2.4/bin/gradle
    - require:
      - archive: gradle_archive
      - pkg: jdk-7
