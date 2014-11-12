.. Copyright (c) 2014, Tomas Neme
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

PYSC
====

``pysc`` stands for "Python Library for Salt-Common", it contains
helper functions and classes used throughout the :doc:`Common
</doc/intro>` python code which provide shortcuts and facilities for
common functionality and configurations such as logging, yaml config
file unserialization, process configuration and most prominently a
base class to create python command line applications that use common
configurations and command line interfaces, and a simplified approach
to crating nrpe checks for your formulas.

Base Application
~~~~~~~~~~~~~~~~

The target of the ``pysc.Application`` class is both to facilitate
creation of command line applications for robotinfra-based (????)
systems and to enforce some kind of standardization on command-line
arguments and configuration files format and locations.

To create a basic application, the user needs to create a class that
inherits from ``pysc.Application``, define the ``main`` method and
call ``run``::

    from psyc import Application

    class MyApp(Application):
        def main(self):
            print self.config

    if __name__ == '__main__':
        MyApp().run()


Options and configurations
--------------------------

``pysc.Application`` provides a set of command line arguments, and
processes all arguments and configuration files a dictionary which the
application can use later on. All values read from configuration
files and command line options are aggregated into a dictionary that
the application class can refer to as ``self.config``. All
configuration files must be yaml files representing a dictionary.

--config
********
The path to the main configuration file. Defaults to
``/etc/python/config.yml"``

Adding custom command line options
**********************************

To add command line options, the Application class has to override
the ``get_argument_parser`` method and add it's desired options to the
parent class' provided ``ArgumentParser``::

    class MyApp(Application):
        def get_argument_parser(self):
            argp = super(MyApp, self).get_argument_parser()
            argp.add_argument("--foo", action=count, default=0,
                              help="How many foos do you want?")
            return argp

        def main(self):
            for _ in range(self.config['foo']):
                print "foo"

Calling this script will behave like this::

    $ test.py
    $ test.py --foo
    foo
    $ test.py --foo --foo --foo
    foo
    foo
    foo

Wherever possible, we encourage to avoid adding command line options.
Usage of the ``--set`` option or config files is preferred, but if the
script is designed to be used manually by the sysadmins then this is
probably the best way.
