include:
  - java.absent

remove_java_env:
  file:
    - sed
    - name: /etc/environment
    - before: export JAVA_HOME="/usr/lib/jvm/java-6-openjdk"
    - after: ""
