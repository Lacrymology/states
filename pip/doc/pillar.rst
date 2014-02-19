:Copyrights: Copyright (c) 2013, Hung Nguyen Viet

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Hung Nguyen Viet

Pillar
======

Optional
--------

Example::

  pip:
    allow_pypi: True

pip:allow_pypi
~~~~~~~~~~~~~~

Value: True/False
When ``file_archives`` is defined in pillar, if this pillar item not
setted/defined or has value ``False`` will make pip use files_archive
as the pkg source.
When it setted to value ``True``, file_archives will act as
a fallback when pkg is not available in pypi offical index.

There is no way to make pypi offical index act as fallback for file_archives
because of the way pip 1.5.x handles pkg sources.
In which, index always be choosen as pkg source when that pkg is available in
both index and file_archives (provided by option ``find-links``).

Default: not defined

pip:proxy_server
~~~~~~~~~~~~~~~~

Proxy server address.

Default: ``False``.
