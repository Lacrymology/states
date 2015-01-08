Usage
=====

This formula also provide the bash library file
``/usr/local/share/salt_common.sh`` that contains some bash functions used in
salt-common:

* ``log_start_script()``: write a message to :doc:`/rsyslog/doc/index` that
  said when it is started and with which arguments.

* ``log_stop_script()``: write a message to :doc:`/rsyslog/doc/index` that said
  it is stopped after how many seconds and what the return code is.

* ``locking_script()``: ensure that only one instance of the script is running.

To use these functions, add the following lines at the top of the script::

  source /usr/local/share/salt-common.sh
  locking_script
  log_start_script "$@"
  trap "log_stop_script \$?" EXIT
