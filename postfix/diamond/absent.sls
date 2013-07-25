{#
 Turn off Diamond statistics for postfix
#}
/etc/diamond/collectors/PostfixCollector.conf:
  file:
    - absent
