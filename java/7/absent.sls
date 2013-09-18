{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
remove_java_7_env:
  cmd:
    - run
    - name: sed -i '\:/usr/lib/jvm/java-7-openjdk:d' /etc/environment
