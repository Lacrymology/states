{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
remove_java_6_env:
  cmd:
    - run
    - name: sed -i '\:/usr/lib/jvm/java-6-openjdk:d' /etc/environment
