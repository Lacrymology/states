include:
  - python
  - jenkins

/var/lib/jenkins/plugins/python.hpi:
  file:
    - managed
    - source: http://updates.jenkins-ci.org/download/plugins/python/1.2/python.hpi
    #TODO mirror
    - source_hash: md5=4f48c7279e4f5b46c49023f31771866c
    - user: jenkins
    - group: nogroup
    - require:
      - pkg: jenkins
      - pkg: python
    - watch_in:
      - service: jenkins
