Troubleshoot
============

How to know the MySQL root password
-------------------------------------

Run the following command::

  debconf-get-selections | grep mysql

Output will be something like this::

  mysql-server-5.5    mysql-server/root_password_again \
  password  KPMRB22Hh93yDiyZOqKe
  mysql-server-5.5    mysql-server/root_password \
  password  KPMRB22Hh93yDiyZOqKe

So the password of `root` user is ``KPMRB22Hh93yDiyZOqKe``.
