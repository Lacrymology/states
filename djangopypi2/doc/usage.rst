Usage
=====

Developers: How to upload packages
----------------------------------

Uploading to your PyPI
~~~~~~~~~~~~~~~~~~~~~~

Assuming you are running your :doc:`/django/doc/index` site locally for now, add the following to
your ``~/.pypirc`` file::

  [distutils]
  index-servers =
    pypi
    local

  [pypi]
  username:user
  password:secret

  [local]
  username:user
  password:secret
  repository:http://localhost:8000/pypi/

Uploading a package: Python >=2.6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To push the package to the local pypi::

  python setup.py register -r local sdist upload -r local

Uploading a package: Python <2.6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you don't have Python 2.6 please run the command below to install the
backport of the extension for multiple repositories::

  easy_install -U collective.dist

Instead of using register and dist command, you can use ``mregister`` and
``mupload`` which are a backport of python 2.6 register and upload commands
that supports multiple servers.

To push the package to the local pypi::

  python setup.py mregister -r local sdist mupload -r local

Users: How to use this server
=============================

Installing a package with pip
-----------------------------

To install your package with pip::

  pip install -i http://my.pypiserver.com/simple/ <PACKAGE>

If you want to fall back to PyPi or another repository in the event the
package is not on your new server, or in particular if you are installing a
number of packages, some on your private server and some on another, you can use
pip in the following manner::

  pip install -i http://pypi.example.com/simple/ \
    --extra-index-url=http://pypi.python.org/simple/ \
    -r requirements.txt

The downside is that each install of a package hosted on the repository in
``--extra-index-url`` will start with a call to the first repository which
will fail before pip falls back to the alternative.
