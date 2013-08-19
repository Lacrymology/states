remove_java_6_env:
  cmd:
    - run
    - name: sed -i '\:/usr/lib/jvm/java-6-openjdk:d' /etc/environment
