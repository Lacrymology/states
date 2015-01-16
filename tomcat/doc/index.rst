..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Tomcat
======

More can be find at official `Apache Tomcat page <http://tomcat.apache.org/>`_.

Apache Tomcat is an open source software implementation of the :doc:`/java/doc/index` Servlet and
JavaServer Pages technologies. The :doc:`/java/doc/index` Servlet and JavaServer Pages
specifications are developed under the :doc:`/java/doc/index` Community Process.

Tomcat6 or Tomcat7
------------------

Users should choose the version which they used for developing
:doc:`/java/doc/index` application.
Consults `this page for more information <http://tomcat.apache.org/whichversion.html>`_.

- Apache Tomcat 6.x builds upon the improvements made in Tomcat 5.5.x and
  implements the Servlet 2.5 and JSP 2.1 specifications. In addition to that,
  it includes the following improvements::

    Memory usage optimizations
    Advanced IO capabilities
    Refactored clustering

- Apache Tomcat 7.x builds upon the improvements made in Tomcat 6.0.x and
  implements the Servlet 3.0, JSP 2.2, EL 2.2 and Web Socket 1.1
  specifications. In addition to that, it includes the following improvements::

    Web application memory leak detection and prevention
    Improved security for the Manager and Host Manager applications
    Generic CSRF protection
    Support for including external content directly in a web application
    Refactoring (connectors, lifecycle) and lots of internal code clean-up

.. toctree::
    :glob:

    *
