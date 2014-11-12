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

Usage
-----

Subclass ``pysc.Application`` and call the ``run`` method, as
described above. Optionally, you can also override the following
class-level attributes:

- `name`: This will be used to change the process name instead of the
  filename.
- `defaults`: An optional dictionary of default configuration values.
  Notice that this has lower priority than command line arguments, so
  if you want to, for example, change the default value of the config
  file, this won't work. To do it, please do the following::

    class MyApp(Application):
        def get_config_parser(self):
            argp = super(MyApp, self).get_config_parser()
            argp.set_defaults(config="/custom/config/path.yml")
            return argp

- `logger`: the logger to be used in case of errors. This can be
  either a string or an instance of ``logging.Logger``, and it
  defaults to the calling class' containing ``__module__``

A more complete example::

    #!/usr/bin/env python

    import pysc

    class MyApp(pysc.Application):
        name = 'my-custom-command'
        defaults = {
            'foo': 1,
            'bar': 2,
        }
        logger = 'custom.logger'

        def get_argument_parser(self):
            argp = super(MyApp, self).get_argument_parser()
            argp.add_argument("--baz", default=3)
            argp.set_defaults(config="/etc/custom/config.yml")
            return argp

        def main(self):
            self.logger.info("Ready to do my thing")
            print "foo", self.config['foo']
            print "bar", self.config['bar']
            print "baz", self.config['baz']
            self.logger.debug("This was configured with %s",
                              self.config['config'])

    if __name__ == '__main__':
        MyApp().run()

And when invoked::

    $ ./myapp
    foo 1
    bar 2
    baz 3

    $ ./myapp --debug
    DEBUG:custom.logger:running main
    INFO:custom.logger:Ready to do my thing
    foo 1
    bar 2
    baz 3
    DEBUG:custom.logger:main finished

    $ ./myapp --debug --set='{"profile": true}'
    DEBUG:custom.logger:running main
    INFO:profile:main started at 2014-11-12 22:42:17.663816
    INFO:custom.logger:Ready to do my thing
    foo 1
    bar 2
    baz 3
    DEBUG:custom.logger:This was configured with /etc/custom/config.yml
    INFO:profile:main ended at 2014-11-12 22:42:17.717612
    INFO:profile:main ran in 0.053796 seconds. (pcputimes(user=0.27, system=0.06))
    DEBUG:custom.logger:main finished

    $ ./myapp --baz BAZ
    foo 1
    bar 2
    baz BAZ

    $ ./myapp --set='{"foo": "FOO", "bar": 42, "baz": 1024}'
    foo FOO
    bar 42
    baz 1024

    $ ps awwx | grep command
    31056 pts/16   T      0:00 my-custom-command
    31064 pts/16   S+     0:00 grep --color=auto command


Options and configurations
--------------------------

``pysc.Application`` provides a set of command line arguments, and
processes all arguments and configuration files a dictionary which the
application can use later on. All values read from configuration
files and command line options are aggregated into a dictionary that
the application class can refer to as ``self.config``. All
configuration files must be yaml files representing a dictionary.

Command line options
++++++++++++++++++++

--config
********

The path to the main configuration file. Defaults to
``/etc/python/config.yml"``.

--debug
*******

Ignores other logging configs and logs to console at all levels. It
also opens a python debugger on error

--set=<json>
************

Set arbitrary configuration options, the option value must be a valid
JSON dictionary (object). This has priority so it overrides any other
configuration sources that might define the same value. Please
remember that strings in JSON are delimited by ``"``, not by ``'``, so
this is valid::

    $ myapp --set='{"profile": true}'

but this is not::

    $ myapp --set="{'profile': true}"

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
