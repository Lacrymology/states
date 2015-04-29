Troubleshoot
============

How to know the MariaDB root password
-------------------------------------

Run the following command::

  debconf-get-selections | grep mysql

Output will be something like this::

  mariadb-server-5.5    mysql-server/root_password_again \
  password  KPMRB22Hh93yDiyZOqKe
  mariadb-server-5.5    mysql-server/root_password \
  password  KPMRB22Hh93yDiyZOqKe

So the password of `root` user is ``KPMRB22Hh93yDiyZOqKe``.
