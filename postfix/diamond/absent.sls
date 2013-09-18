{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Turn off Diamond statistics for postfix
-#}
postfix_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/PostfixCollector.conf
