include:
  - java.absent

remove_java_env:
  cmd:
    - run
    - name: sed -i '\:/usr/lib/jvm/java-7-openjdk:d' /etc/environment
